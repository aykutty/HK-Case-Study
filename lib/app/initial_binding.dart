import 'package:case_study/data/repositories/login_session_repository.dart';
import 'package:case_study/data/repositories/user_repository.dart';
import 'package:case_study/modules/auth/auth_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository(), permanent: true);
    Get.put(LoginSessionRepository(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
