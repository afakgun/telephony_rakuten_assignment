import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/utils/country_code_utils.dart';
import 'home_controller.dart';
import 'home_widgets.dart';
import '../../utils/textstyle_utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ana Sayfa',
          style: TextStyleUtils.blackColorBoldText(20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Obx(() => UserInfoHeader(
                  name: controller.userName.value,
                  phone: controller.userPhone.value,
                  countryCode: CountryCodeUtils().countryPhoneCodeToNameMap(controller.userCountryCode.value),
                )),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: const [
                  CallCard(),
                  SizedBox(height: 24),
                  SmsCard(),
                  SizedBox(height: 16),
                  YoutubeCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
