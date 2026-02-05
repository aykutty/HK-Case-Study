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
  Timer? _expiryTimer;                                                                                                               
  bool _isProcessing = false; 

  Future<void> startQrLogin() async {
    try {
      isLoading.value = true;
      error.value = '';
      _isProcessing = false; 

      final id = await repo.createSession();
      sessionId.value = id;
      _listenSession(id);
      _startExpiryTimer();
    } catch (e) {
      error.value = 'QR oluşturulamadı';
    } finally {
      isLoading.value = false;
    }
  }

  void _listenSession(String id) {
    _sub?.cancel();

    _sub = repo.watchSession(id).listen((doc) async {
      if (!doc.exists || _isProcessing) return;  

      final data = doc.data()!;
      if (data['status'] == 'approved') {
        _isProcessing = true;
        _sub?.cancel();
        _expiryTimer?.cancel();

        try {
          final callable = functions.httpsCallable('createWebLoginToken');

          final result = await callable.call({'sessionId': id});
          final token = result.data['token'];

          await _auth.signInWithCustomToken(token);

          Get.offAllNamed(Routes.webProfile);
        } catch (e) {
          _isProcessing = false;
          print('Web login error: $e');
          error.value = 'Web giriş yapılamadı: $e';
        }
      }
    });
  }

  void _startExpiryTimer() {                                                                                                         
     _expiryTimer?.cancel();                                                                                                          
     _expiryTimer = Timer(const Duration(minutes: 3), () {                                                                            
       _sub?.cancel();                                                                                                                
       sessionId.value = '';                                                                                                          
       error.value = 'QR kodunun süresi doldu. Lütfen yeniden oluşturun.';                                                            
     });                                                                                                                              
   }     

  @override
  void onClose() {
    _sub?.cancel();
    _expiryTimer?.cancel();
    super.onClose();
  }
}
