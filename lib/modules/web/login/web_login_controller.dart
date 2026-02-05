import 'dart:async';
import 'package:case_study/data/repositories/login_session_repository.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:case_study/app/routes.dart';

class WebLoginController extends GetxController {
  final LoginSessionRepository repo = Get.find<LoginSessionRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  final RxBool isLoading = false.obs;
  final RxString sessionId = ''.obs;
  final RxString error = ''.obs;

  StreamSubscription? _sub;

  Future<void> startQrLogin() async {
    try {
      isLoading.value = true;
      error.value = '';

      final id = await repo.createSession();
      sessionId.value = id;
      _listenSession(id);
    } catch (e) {
      error.value = 'QR oluşturulamadı';
    } finally {
      isLoading.value = false;
    }
  }

  void _listenSession(String id) {
    _sub?.cancel();

    _sub = repo.watchSession(id).listen((doc) async {
      if (!doc.exists) return;

      final data = doc.data()!;
      if (data['status'] == 'approved') {
        try {
          final callable = functions.httpsCallable('createWebLoginToken');

          final result = await callable.call({'sessionId': id});
          final token = result.data['token'];

          await _auth.signInWithCustomToken(token);

          Get.offAllNamed(Routes.webProfile);
        } catch (e) {
          print('Web login error: $e');
          error.value = 'Web giriş yapılamadı: $e';
        }
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
