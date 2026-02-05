import 'package:case_study/app/ui/background/app_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'web_login_controller.dart';
import 'package:case_study/app/ui/buttons/cs_custom_button.dart';

class WebLoginPage extends GetView<WebLoginController> {
  const WebLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/hklogo.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'HIZLI KREDİ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (controller.error.isNotEmpty)
                      Text(
                        controller.error.value,
                        style: const TextStyle(color: Colors.red),
                      ),

                    if (controller.sessionId.isEmpty)
                      CustomButton(
                        text: 'QR Oluştur',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.startQrLogin,
                      )
                    else
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data: controller.sessionId.value,
                              size: 220,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Telefonunuzdan QR kodu okutun',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
