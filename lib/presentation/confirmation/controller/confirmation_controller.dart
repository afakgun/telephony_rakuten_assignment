import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/models/user_models.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart'; // Import DialogUtils

class ConfirmationController extends GetxController {
  final String verificationId;
  final String phoneNumber;
  final String countryCode;
  final code = ''.obs;
  final isCodeValid = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  ConfirmationController({
    required this.verificationId,
    required this.phoneNumber,
    required this.countryCode,
  });

  void onCodeChanged(String value) {
    code.value = value;
    isCodeValid.value = value.length == 6;
    errorMessage.value = '';
  }

  Future<void> resendCode() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final service = WelcomeService();
      await service.sendOtp(
        phoneNumber: phoneNumber,
        onCodeSent: (newVerificationId) {
          Get.snackbar('Başarılı', 'Kod tekrar gönderildi.');
        },
        onError: (e) {
          errorMessage.value = 'Kod tekrar gönderilemedi: ${e.message}';
        },
      );
    } catch (e) {
      errorMessage.value = 'Kod tekrar gönderilemedi.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onConfirmPressed() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final service = WelcomeService();
      final userCredential = await service.verifyOtp(
        verificationId: verificationId,
        smsCode: code.value,
      );
      final user = userCredential.user;
      if (user != null) {
        await checkUserAndNavigate(user.uid);
      } else {
        errorMessage.value = 'Kullanıcı doğrulanamadı.';
      }
    } catch (e) {
      errorMessage.value = 'Kod doğrulanamadı. Lütfen tekrar deneyin. \n ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkUserAndNavigate(String uid) async {
    try {
      final service = WelcomeService(); // Assuming WelcomeService handles Firestore
      final user = await service.getUserFromFirestore(uid);

      if (user != null) {
        // User exists, navigate to home
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString("user_uid", uid);
        Get.offAllNamed('/home');
      } else {
        // User does not exist, show dialog for name and surname
        await showNewUserDialog(uid);
      }
    } catch (e) {
      errorMessage.value = 'Kullanıcı kontrol edilirken bir hata oluştu.';
    }
  }

  Future<void> showNewUserDialog(String uid) async {
    String firstName = '';
    String lastName = '';

    await Get.defaultDialog(
      title: 'Yeni Kullanıcı',
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Ad'),
            onChanged: (value) => firstName = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Soyad'),
            onChanged: (value) => lastName = value,
          ),
        ],
      ),
      textConfirm: 'Kaydet',
      onConfirm: () async {
        if (firstName.isNotEmpty && lastName.isNotEmpty) {
          final newUser = UserModel(
            uid: uid,
            phoneNumber: phoneNumber,
            firstName: firstName,
            lastName: lastName,
            countryCode: countryCode,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await WelcomeService().saveUserToFirestore(
            uid: newUser.uid,
            phoneNumber: newUser.phoneNumber,
            firstName: newUser.firstName,
            lastName: newUser.lastName,
            countryCode: newUser.countryCode,
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString("user_uid", uid);

          await prefs.setString("user_credential", json.encode(newUser.toJson()));
          Get.offAllNamed('/home');
        } else {
          errorMessage.value = 'Ad ve Soyad boş bırakılamaz.';
        }
      },
      textCancel: 'İptal',
      onCancel: () {
        Get.back();
        // Handle cancellation if needed
      },
    );
  }
}
