import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart';
import 'welcome_service.dart';

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
          errorMessage.value = 'otp_not_sent'.trParams({'error': e.message ?? ''});
        },
      );
    } catch (e) {
      errorMessage.value = 'error_occurred'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
