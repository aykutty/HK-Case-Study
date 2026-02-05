import 'package:get/get.dart';
import 'package:case_study/modules/auth/phone_page.dart';
import 'package:case_study/modules/profile/profile_controller.dart';
import 'package:case_study/modules/profile/profile_page.dart';
import 'package:case_study/modules/web/login/web_login_page.dart';
import 'package:case_study/modules/web/profile/web_profile_page.dart';
import 'package:case_study/modules/web/login/web_login_controller.dart';
import 'package:case_study/modules/web/profile/web_profile_controller.dart';

class Routes {
  static const phone = '/phone';
  static const profile = '/profile';

  static const webLogin = '/web';
  static const webProfile = '/web/profile';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.phone, page: () => const PhonePage()),

    GetPage(
      name: Routes.profile,
      page: () => ProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),

    GetPage(
      name: Routes.webLogin,
      page: () => const WebLoginPage(),
      binding: BindingsBuilder(() {
        Get.put(WebLoginController());
      }),
    ),

    GetPage(
      name: Routes.webProfile,
      page: () => const WebProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(WebProfileController());
      }),
    ),
  ];
}
