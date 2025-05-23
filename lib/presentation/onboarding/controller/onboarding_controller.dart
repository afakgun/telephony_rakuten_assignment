import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';

class OnboardingPageModel {
  final String image;
  final String title;
  final String description;

  OnboardingPageModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  final pageController = PageController();

  final onboardingPages = [
    OnboardingPageModel(
      image: 'assets/images/onboarding_1.jpg',
      title: 'voice_call_title'.tr,
      description: 'voice_call_desc'.tr,
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_2.jpg',
      title: 'youtube_usage_title'.tr,
      description: 'youtube_usage_desc'.tr,
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_3.jpg',
      title: 'send_sms_title'.tr,
      description: 'send_sms_desc'.tr,
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_4.jpg',
      title: 'kpi_tracking_title'.tr,
      description: 'kpi_tracking_desc'.tr,
    ),
  ];

  void nextPage() {
    if (selectedPageIndex.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: 300.milliseconds,
        curve: Curves.ease,
      );
    } else {
      skipOnboarding();
    }
  }

  void skipOnboarding() async {
    await SharedPreferencesService.setBool('onboarding_seen', true);
    Get.offNamed(Routes.WELCOME);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
