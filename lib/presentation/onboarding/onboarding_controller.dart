import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart'; // Assuming you have a routes file

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
      image: 'assets/images/onboarding_1.jpg', // Placeholder
      title: 'Sesli Arama', // TODO: Localize
      description: 'Belirtilen numaraya sesli arama başlatın ve arama süresini takip edin.', // TODO: Localize
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_2.jpg', // Placeholder
      title: 'Veri Kullanımı (Youtube)', // TODO: Localize
      description: 'Belirtilen URL\'den Youtube videosu izleyin ve veri kullanımını sınırlayın (yalnızca hücresel veri).', // TODO: Localize
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_3.jpg', // Placeholder
      title: 'SMS Gönderme', // TODO: Localize
      description: 'Belirtilen numaraya özel mesaj içeriği ile SMS gönderin.', // TODO: Localize
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding_4.jpg', // Placeholder
      title: 'KPI Takibi', // TODO: Localize
      description: 'Uygulama özelliklerinin kullanımına ilişkin önemli performans göstergelerini (KPI) görüntüleyin.', // TODO: Localize
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

  void skipOnboarding() {
    // Navigate to the next screen after onboarding, e.g., WelcomeView
    Get.offNamed(Routes.WELCOME); // Assuming you have a route named WELCOME
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
