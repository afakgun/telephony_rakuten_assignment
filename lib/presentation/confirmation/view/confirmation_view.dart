import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/widgets/confirmation_code_input_widget.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/controller/confirmation_controller.dart';
import '../../../utils/button_utils.dart';
import '../../../const/app_colors.dart';

class ConfirmationView extends GetView<ConfirmationController> {
  const ConfirmationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verification_code'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'enter_verification_code'.tr,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ConfirmationCodeInput(
              onChanged: controller.onCodeChanged,
              controller: controller.codeController,
            ),
            const SizedBox(height: 32),
            Obx(() => ButtonUtils.cardButton(
                  onTap: controller.isCodeValid.value ? () => controller.onConfirmPressed(context) : null,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  enabled: controller.isCodeValid.value,
                  verticalPadding: 16,
                  fontSize: 18,
                  child: Text('continue'.tr, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                )),
            TextButton(
              onPressed: () => controller.resendCode(context),
              child: Text('resend'.tr),
            ),
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
