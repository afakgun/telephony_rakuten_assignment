import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/view/confirmation_view.dart';
import 'package:telephony_rakuten_assignment/presentation/home/home_view.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_view.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/welcome_view.dart';
import 'package:telephony_rakuten_assignment/presentation/confirmation/confirmation_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/home/home_binding.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/youtube_player_view.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/youtube_binding.dart';

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
