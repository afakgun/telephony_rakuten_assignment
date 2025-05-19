import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/models/user_models.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_service.dart';

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
          Get.snackbar('success'.tr, 'code_resent'.tr);
        },
        onError: (e) {
          errorMessage.value = '${'code_not_resent'.tr}: ${e.message}';
        },
      );
    } catch (e) {
      errorMessage.value = 'code_not_resent'.tr;
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
        errorMessage.value = 'user_not_verified'.tr;
      }
    } catch (e) {
      errorMessage.value = '${'code_not_verified'.tr} \n ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkUserAndNavigate(String uid) async {
    try {
      final service = WelcomeService();
      final user = await service.getUserFromFirestore(uid);

      if (user != null) {
        await SharedPreferencesService.setBool('isLoggedIn', true);
        await SharedPreferencesService.setString("user_uid", uid);
        Get.offAllNamed('/home');
      } else {
        await showNewUserDialog(uid);
      }
    } catch (e) {
      errorMessage.value = 'user_check_error'.tr;
    }
  }

  Future<void> showNewUserDialog(String uid) async {
    String firstName = '';
    String lastName = '';

    await Get.defaultDialog(
      title: 'new_user'.tr,
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
          await SharedPreferencesService.setBool('isLoggedIn', true);
          await SharedPreferencesService.setString("user_uid", uid);
          await SharedPreferencesService.setString("user_credential", json.encode(newUser.toJson()));
          Get.offAllNamed('/home');
        } else {
          errorMessage.value = 'name_surname_empty'.tr;
        }
      },
      textCancel: 'cancel'.tr,
      onCancel: () {
        Get.back();
      },
    );
  }
}
