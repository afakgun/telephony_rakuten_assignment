import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_controller.dart'; // Assuming you have this

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}
