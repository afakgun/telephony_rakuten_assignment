import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/controller/confirmation_controller.dart';

class ConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmationController>(
      () => ConfirmationController(
        // TODO: Pass required parameters to ConfirmationController
        verificationId: Get.arguments['verificationId'],
        phoneNumber: Get.arguments['phoneNumber'],
        countryCode: Get.arguments['countryCode'],
      ),
    );
  }
}
