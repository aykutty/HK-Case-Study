import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:case_study/modules/auth/auth_controller.dart';
import 'package:case_study/app/ui/fields/pill_input.dart';
import 'package:case_study/app/ui/buttons/cs_custom_button.dart';

class OtpVerifyDialog extends StatelessWidget {
  OtpVerifyDialog({super.key});

  final controller = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const Text(
                  'Onay Kodunu Doğrulayın',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0A1E3F),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Telefonunuza gönderilen 6 haneli kodu girin',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 32),

                PillInput(
                  controller: otpController,
                  hint: 'Doğrulama Kodu',
                  icon: Icons.lock,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 24),

                Obx(() {
                  return CustomButton(
                    text: 'Kodu Doğrula',
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.verifyOtp(otpController.text.trim());
                    },
                  );
                }),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
