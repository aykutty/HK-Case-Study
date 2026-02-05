import 'package:case_study/app/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:case_study/app/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: InitialBinding(),
      initialRoute: kIsWeb ? Routes.webLogin : Routes.phone,
      getPages: AppPages.pages,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 36, 117, 239),
      ),
    );
  }
}
