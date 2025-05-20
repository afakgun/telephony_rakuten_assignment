import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/models/user_models.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/service/welcome_service.dart';
import 'package:telephony_rakuten_assignment/utils/loading_utils.dart';
import 'package:telephony_rakuten_assignment/utils/textfield_utils.dart';
import 'package:telephony_rakuten_assignment/utils/button_utils.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';

class ConfirmationController extends GetxController {
  final String verificationId;
  final String phoneNumber;
  final String countryCode;
  TextEditingController codeController = TextEditingController();
  OTPTextEditController? otpTextEditController;

  final code = ''.obs;
  final isCodeValid = false.obs;
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

  Future<void> resendCode(BuildContext context) async {
    errorMessage.value = '';
    try {
      LoadingUtils.startLoading(context);
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
      LoadingUtils.stopLoading();
    }
  }

  Future<void> onConfirmPressed(BuildContext context) async {
    errorMessage.value = '';
    try {
      LoadingUtils.startLoading(context);
      final service = WelcomeService();
      final userCredential = await service.verifyOtp(
        verificationId: verificationId,
        smsCode: code.value,
      );
      final user = userCredential.user;
      if (user != null) {
        await checkUserAndNavigate(user.uid, context);
      } else {
        errorMessage.value = 'user_not_verified'.tr;
      }
    } catch (e) {
      errorMessage.value = '${'code_not_verified'.tr} \n ${e.toString()}';
    } finally {
      LoadingUtils.stopLoading();
    }
  }

  Future<void> checkUserAndNavigate(String uid, BuildContext context) async {
    try {
      LoadingUtils.startLoading(context);
      final service = WelcomeService();
      final user = await service.getUserFromFirestore(uid);
      LoadingUtils.stopLoading();

      if (user != null) {
        await SharedPreferencesService.setBool('isLoggedIn', true);
        await SharedPreferencesService.setString("user_uid", uid);
        Get.offAllNamed('/home');
      } else {
        await showNewUserDialog(uid);
      }
    } catch (e) {
      errorMessage.value = 'user_check_error'.tr;
    } finally {
      LoadingUtils.stopLoading();
    }
  }

  Future<void> showNewUserDialog(String uid) async {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    await Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Get.width * .85,
            minWidth: Get.width * .8,
            maxHeight: Get.height * 0.7,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'new_user'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 8),
                  // TextFieldUtils ile isim alanı
                  TextFieldUtils.cardTextField(
                    controller: firstNameController,
                    hintText: 'first_name'.tr,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 12),
                  // TextFieldUtils ile soyisim alanı
                  TextFieldUtils.cardTextField(
                    controller: lastNameController,
                    hintText: 'last_name'.tr,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonUtils.cardButton(
                          text: 'cancel'.tr,
                          onTap: () {
                            Get.back();
                          },
                          backgroundColor: Colors.white,
                          textColor: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ButtonUtils.cardButton(
                          text: 'save'.tr,
                          onTap: () async {
                            final firstName = firstNameController.text.trim();
                            final lastName = lastNameController.text.trim();
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
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withAlpha((255 * 0.3).toInt()),
    );
  }

  void listenSms() {
    if (Platform.isAndroid) {
      final OTPInteractor _otpInteractor = OTPInteractor();

      _otpInteractor.getAppSignature().then((value) => log('signature - $value'));
      otpTextEditController = OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          log('code - $code');
          codeController.text = code;
        },
        onTimeOutException: () {
          otpTextEditController?.startListenUserConsent(
            (code) {
              log('code ex - $code');
              final exp = RegExp(r'(\d{6})');
              return exp.stringMatch(code ?? '') ?? '';
            },
          );
        },
      )..startListenUserConsent(
          (code) {
            log('code user - $code');
            final exp = RegExp(r'(\d{6})');
            return exp.stringMatch(code ?? '') ?? '';
          },
        );
    }
    // For iOS, no need to implement anything as it uses native autofill
  }
}
