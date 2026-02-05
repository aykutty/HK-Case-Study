import 'package:case_study/app/ui/background/app_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:case_study/modules/auth/auth_controller.dart';
import 'package:case_study/app/ui/fields/pill_input.dart';
import 'package:case_study/app/ui/buttons/cs_custom_button.dart';
import 'package:case_study/app/utils/phone_num_formatter.dart';

class PhonePage extends GetView<AuthController> {
  PhonePage({super.key});

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/hklogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'HIZLI KREDİ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 255, 255, 255), // lacivert
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 48),

                  PillInput(
                    controller: phoneController,
                    hint: 'Telefon numaranız',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  Obx(() {
                    return CustomButton(
                      text: 'Giriş Yap',
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        final formattedPhone = formatPhoneNumber(
                          phoneController.text,
                        );
                        controller.sendOtp(formattedPhone);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
