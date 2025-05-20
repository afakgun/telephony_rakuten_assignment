import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/view/confirmation_view.dart';
import 'package:telephony_rakuten_assignment/presentation/home/view/home_view.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/binding/onboarding_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/view/onboarding_view.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/binding/welcome_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/view/welcome_view.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/binding/confirmation_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/home/binding/home_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/view/youtube_player_view.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/binding/youtube_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

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
      page: () => ConfirmationView(),
      binding: ConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.YOUTUBE,
      page: () => YoutubePlayerView(),
      binding: YoutubeBinding(),
    ),
  ];
}
