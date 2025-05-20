import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/controller/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}
