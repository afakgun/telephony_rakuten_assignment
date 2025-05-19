import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/confirmation_widgets.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/controller/confirmation_controller.dart';

class ConfirmationView extends GetView<ConfirmationController> {


  const ConfirmationView({
    super.key,

  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Doğrulama Kodu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Telefonunuza gönderilen 6 haneli doğrulama kodunu giriniz.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ConfirmationCodeInput(
              onChanged: controller.onCodeChanged,
            ),
            const SizedBox(height: 16),
            Obx(() => TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.resendCode,
                  child: const Text('Tekrar Gönder'),
                )),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: controller.isCodeValid.value
                      ? controller.onConfirmPressed
                      : null,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Onayla'),
                )),
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
