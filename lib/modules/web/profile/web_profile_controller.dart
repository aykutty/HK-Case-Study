import 'package:case_study/data/models/app_user.dart';
import 'package:case_study/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WebProfileController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = true.obs;
  final Rx<AppUser?> user = Rx<AppUser?>(null);
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      error.value = 'Oturum bulunamadı';
      isLoading.value = false;
      return;
    }
    _loadUser(uid);
  }

  Future<void> _loadUser(String uid) async {
    try {
      final result = await _userRepo.getUser(uid);

      if (result == null) {
        error.value = 'Kullanıcı bulunamadı';
      } else {
        user.value = result;
      }
    } catch (e) {
      error.value = 'Kullanıcı bilgileri yüklenemedi';
    } finally {
      isLoading.value = false;
    }
  }
}
