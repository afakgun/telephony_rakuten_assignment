import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_controller.dart';
import 'package:telephony_rakuten_assignment/presentation/onboarding/onboarding_widgets.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.onboardingPages.length,
            onPageChanged: controller.selectedPageIndex,
            itemBuilder: (context, index) {
              return OnboardingPage(
                image: controller.onboardingPages[index].image,
                title: controller.onboardingPages[index].title,
                description: controller.onboardingPages[index].description,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text('skip'.tr),
                ),
                Row(
                  children: List.generate(
                    controller.onboardingPages.length,
                    (index) => Obx(() {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: controller.selectedPageIndex.value == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.selectedPageIndex.value == index ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ),
                FloatingActionButton(
                  onPressed: controller.nextPage,
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
