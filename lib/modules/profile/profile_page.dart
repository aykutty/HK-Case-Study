import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import 'package:case_study/app/ui/buttons/cs_custom_button.dart';
import 'package:case_study/app/ui/fields/profile_field.dart';
import 'package:case_study/app/ui/background/app_background.dart';
import 'package:case_study/app/utils/date_formatter.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = controller.user.value;
            if (user == null) {
              return const Center(child: Text('Kullanıcı bulunamadı'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(
                        0.15,
                      ), // 👈 soft arka plan
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 56, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 32),

                  ProfileField(
                    label: 'Kullanıcı ID',
                    value: user.uid,
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  ProfileField(
                    label: 'Telefon Numarası',
                    value: user.phoneNumber,
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 16),

                  ProfileField(
                    label: 'Oluşturulma Tarihi',
                    value: formatDate(user.createdAt),
                    icon: Icons.calendar_today,
                  ),

                  const SizedBox(height: 16),

                  ProfileField(
                    label: 'Son Giriş',
                    value: formatDate(user.lastLoginAt),
                    icon: Icons.login,
                  ),

                  const SizedBox(height: 32),

                  CustomButton(
                    onPressed: controller.openQrScanner,
                    text: '',
                    textWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'QR Okut',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  CustomButton(
                    onPressed: controller.logout,
                    text: '',
                    textWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Çıkış Yap',
                          style: TextStyle(
                            color: Color.fromARGB(255, 252, 1, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 255, 0, 0),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
