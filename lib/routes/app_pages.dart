import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/home/home_view.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_binding.dart'; // Assuming you will create this
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_view.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_binding.dart'; // Assuming you have this
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_view.dart';
import 'package:telephony_rakuten_assignment/ui/confirmation/confirmation_view.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/confirmation_binding.dart'; // Import ConfirmationBinding
import 'package:telephony_rakuten_assignment/presentation/home/home_binding.dart'; // Import HomeBinding

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRMATION,
      page: () =>  ConfirmationView(),
      binding: ConfirmationBinding(),
    ),
     GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
