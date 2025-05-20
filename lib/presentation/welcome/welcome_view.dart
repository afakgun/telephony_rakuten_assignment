import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';
import 'welcome_controller.dart';
import 'welcome_widgets.dart';
import '../../utils/button_utils.dart';
import '../../const/app_colors.dart';

class WelcomeView extends StatelessWidget {
  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    ever(controller.errorMessage, (String msg) {
      if (msg.isNotEmpty) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'error'.tr,
          message: msg,
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Kapat',
          buttonRightAction: () => Get.back(),
          isDismissable: true,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome'.tr,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'fill_fields'.tr,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  CountryCodeDropdown(
                    value: controller.countryCode.value,
                    onChanged: (value) {
                      if (value != null) controller.countryCode.value = value;
                    },
                    items: [
                      CountryCodeItem(code: '+90', flagAsset: 'assets/svg/flags/tr.svg'),
                      CountryCodeItem(code: '+1', flagAsset: 'assets/svg/flags/us.svg'),
                      CountryCodeItem(code: '+44', flagAsset: 'assets/svg/flags/gb.svg'),
                      CountryCodeItem(code: '+34', flagAsset: 'assets/svg/flags/es.svg'),
                      CountryCodeItem(code: '+81', flagAsset: 'assets/svg/flags/jp.svg'),
                      CountryCodeItem(code: '+49', flagAsset: 'assets/svg/flags/de.svg'),
                      CountryCodeItem(code: '+971', flagAsset: 'assets/svg/flags/ae.svg'),
                      CountryCodeItem(code: '+966', flagAsset: 'assets/svg/flags/sa.svg'),
                      CountryCodeItem(code: '+20', flagAsset: 'assets/svg/flags/eg.svg'),
                      CountryCodeItem(code: '+7', flagAsset: 'assets/svg/flags/ru.svg'),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: WelcomeTextField(
                      label: 'phone_number'.tr,
                      hint: 'phone_number_hint'.tr,
                      onChanged: (v) => controller.phoneNumber.value = v,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Obx(() => ButtonUtils.cardButton(
                    onTap: controller.isFormValid
                        ? () async {
                            await controller.sendOtp();
                            if (controller.errorMessage.isEmpty) {}
                          }
                        : null,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    enabled: controller.isFormValid,
                    verticalPadding: 16,
                    fontSize: 18,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('continue'.tr, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
