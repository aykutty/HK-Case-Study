import 'package:case_study/app/routes.dart';
import 'package:case_study/data/repositories/login_session_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:case_study/data/repositories/user_repository.dart';
import 'package:case_study/data/models/app_user.dart';
import 'package:case_study/modules/qr/qr_scan_page.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LoginSessionRepository _sessionRepository =
      Get.find<LoginSessionRepository>();

  final RxBool isLoading = true.obs;
  final Rx<AppUser?> user = Rx<AppUser?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  final RxString error = ''.obs;

  Future<void> _loadUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      user.value = await _userRepo.getUser(uid);
    } catch (e) {
      error.value = 'Kullanıcı bilgileri yüklenemedi';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.phone);
  }

  Future<void> openQrScanner() async {
    final sessionId = await Get.to(() => const QrScanPage());

    if (sessionId == null) return;

    try {
      await _approveQrSession(sessionId);

      Get.snackbar(
        'Başarılı',
        'Web oturumu başarıyla onaylandı',
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text('Başarılı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        messageText: const Text('Web oturumu başarıyla onaylandı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      );
    } catch (e) {
      print('QR approve error: $e');
      Get.snackbar(
        'Hata',
        'QR oturumu onaylanamadı: $e',
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text('Hata', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        messageText: Text('QR oturumu onaylanamadı: $e', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _approveQrSession(String sessionId) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('Login olmadan QR onaylanamaz');
    }

    await _sessionRepository.approveSession(
      sessionId: sessionId,
      userId: firebaseUser.uid,
    );
  }
}