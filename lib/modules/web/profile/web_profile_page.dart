import 'package:case_study/app/ui/background/app_background.dart';
import 'package:case_study/app/ui/fields/profile_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'web_profile_controller.dart';
import 'package:case_study/app/utils/date_formatter.dart';

class WebProfilePage extends GetView<WebProfileController> {
  const WebProfilePage({super.key});

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

            if (controller.error.isNotEmpty) {
              return Center(
                child: Text(
                  controller.error.value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final user = controller.user.value!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                  ),

                  const SizedBox(height: 32),

                  ProfileField(
                    label: 'Kullanıcı ID',
                    value: user.uid,
                    icon: Icons.fingerprint,
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
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
