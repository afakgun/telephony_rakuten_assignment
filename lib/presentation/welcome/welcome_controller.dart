import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart'; // Import AppPages for Routes
import 'welcome_service.dart';
import '../confirmation/view/confirmation_view.dart';

class WelcomeController extends GetxController {
  final countryCode = '+90'.obs;
  final phoneNumber = ''.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  bool get isFormValid => countryCode.value.isNotEmpty && phoneNumber.value.isNotEmpty;

  Future<void> sendOtp() async {
    if (!isFormValid) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await WelcomeService().sendOtp(
        phoneNumber: '${countryCode.value}${phoneNumber.value}',
        onCodeSent: (verificationId) {
          Get.toNamed(Routes.CONFIRMATION, arguments: {
            'verificationId': verificationId,
            'phoneNumber': '${countryCode.value}${phoneNumber.value}',
            'countryCode': countryCode.value,
          });
        },
        onError: (e) {
          errorMessage.value = 'OTP gönderilemedi: ${e.message}';
        },
      );
    } catch (e) {
      errorMessage.value = 'Bir hata oluştu';
    } finally {
      isLoading.value = false;
    }
  }

  // TODO: Implement checkUserInFirestore and handle navigation/user creation
  // Future<void> checkUserInFirestore(String uid) async { ... }
}
