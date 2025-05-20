import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/model/country_code_model.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/widgets/welcome_textfield_widget.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';
import '../controller/welcome_controller.dart';
import '../widgets/country_code_dropdown_widget.dart';
import '../../../utils/button_utils.dart';
import '../../../const/app_colors.dart';

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
                  Obx(
                    () => Container(
                      width: Get.width * 0.25,
                      child: CountryCodeDropdown(
                        value: controller.countryCode.value,
                        onChanged: (value) {
                          if (value != null) controller.countryCode.value = value;
                        },
                        items: [
                          CountryCodeItem(code: '+1', flagAsset: 'assets/svg/flags/us.svg'),
                          CountryCodeItem(code: '+90', flagAsset: 'assets/svg/flags/tr.svg'),
                          CountryCodeItem(code: '+44', flagAsset: 'assets/svg/flags/gb.svg'),
                          CountryCodeItem(code: '+34', flagAsset: 'assets/svg/flags/es.svg'),
                          CountryCodeItem(code: '+81', flagAsset: 'assets/svg/flags/jp.svg'),
                          CountryCodeItem(code: '+49', flagAsset: 'assets/svg/flags/de.svg'),
                          CountryCodeItem(code: '+971', flagAsset: 'assets/svg/flags/ae.svg'),
                          CountryCodeItem(code: '+966', flagAsset: 'assets/svg/flags/sa.svg'),
                          CountryCodeItem(code: '+20', flagAsset: 'assets/svg/flags/eg.svg'),
                          CountryCodeItem(code: '+7', flagAsset: 'assets/svg/flags/ru.svg'),
                          CountryCodeItem(code: '+994', flagAsset: 'assets/svg/flags/az.svg'),
                          CountryCodeItem(code: '+62', flagAsset: 'assets/svg/flags/id.svg'),
                          CountryCodeItem(code: '+86', flagAsset: 'assets/svg/flags/cn.svg'),
                          CountryCodeItem(code: '+82', flagAsset: 'assets/svg/flags/kr.svg'),
                          CountryCodeItem(code: '+39', flagAsset: 'assets/svg/flags/it.svg'),
                          CountryCodeItem(code: '+33', flagAsset: 'assets/svg/flags/fr.svg'),
                          CountryCodeItem(code: '+63', flagAsset: 'assets/svg/flags/ph.svg'),
                          CountryCodeItem(code: '+65', flagAsset: 'assets/svg/flags/sg.svg'),
                          CountryCodeItem(code: '+66', flagAsset: 'assets/svg/flags/th.svg'),
                          CountryCodeItem(code: '+84', flagAsset: 'assets/svg/flags/vn.svg'),
                          CountryCodeItem(code: '+60', flagAsset: 'assets/svg/flags/my.svg'),
                          CountryCodeItem(code: '+91', flagAsset: 'assets/svg/flags/in.svg'),
                          CountryCodeItem(code: '+92', flagAsset: 'assets/svg/flags/pk.svg'),
                          CountryCodeItem(code: '+880', flagAsset: 'assets/svg/flags/bd.svg'),
                          CountryCodeItem(code: '+977', flagAsset: 'assets/svg/flags/np.svg'),
                          CountryCodeItem(code: '+94', flagAsset: 'assets/svg/flags/lk.svg'),
                        ],
                      ),
                    ),
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
                            await controller.sendOtp(context);
                            if (controller.errorMessage.isEmpty) {}
                          }
                        : null,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    enabled: controller.isFormValid,
                    verticalPadding: 16,
                    fontSize: 18,
                    child: Text('continue'.tr, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
