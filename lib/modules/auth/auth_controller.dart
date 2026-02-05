import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:case_study/app/routes.dart';
import 'package:case_study/app/ui/dialogs/error_dialog.dart';
import 'package:case_study/data/repositories/user_repository.dart';
import 'package:case_study/app/ui/dialogs/otp_verify_dialog.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepo = Get.find<UserRepository>();

  final RxBool isLoading = false.obs;
  final RxString verificationId = ''.obs;
  final RxString error = ''.obs;

  final phoneTextController = TextEditingController();
  final otpTextController = TextEditingController();

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    error.value = '';

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
          await _onLoginSuccess();
        } catch (_) {
          showErrorDialog(
            title: 'Hata',
            message: 'Otomatik doğrulama sırasında hata oluştu.',
          );
        } finally {
          isLoading.value = false;
        }
      },

      verificationFailed: (FirebaseAuthException e) {
        isLoading.value = false;
        showErrorDialog(
          title: 'Doğrulama Hatası',
          message: e.message ?? 'Telefon numarası doğrulanamadı.',
        );
      },

      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        isLoading.value = false;

        Get.bottomSheet(
          OtpVerifyDialog(),
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    if (verificationId.value.isEmpty) {
      showErrorDialog(
        title: 'Oturum Süresi Doldu',
        message: 'Lütfen tekrar giriş yapın.',
      );
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      await _onLoginSuccess();
    } on FirebaseAuthException {
      showErrorDialog(
        title: 'Hatalı Kod',
        message: 'Girdiğiniz doğrulama kodu yanlış veya süresi dolmuş.',
      );
    } catch (_) {
      showErrorDialog(
        title: 'Bağlantı Hatası',
        message: 'Bir sorun oluştu. Lütfen tekrar deneyin.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _onLoginSuccess() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;

    await _userRepo.onUserLogin(
      uid: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber ?? '',
    );
    phoneTextController.clear();
    otpTextController.clear();

    Get.back();
    Get.offAllNamed(Routes.profile);
  }

  @override
  void onClose() {
    phoneTextController.dispose();
    otpTextController.dispose();
    super.onClose();
  }
}
