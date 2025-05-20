import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../utils/textstyle_utils.dart';
import '../../utils/button_utils.dart';
import '../../const/app_colors.dart';

class UserInfoHeader extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? countryCode;
  const UserInfoHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svg/flags/$countryCode.svg',
          width: 36,
          height: 36,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name ?? 'user_not_found'.tr, style: TextStyleUtils.blackColorBoldText(16)),
            Text(phone ?? 'phone_not_found'.tr, style: TextStyleUtils.blackColorRegularText(14)),
          ],
        ),
      ],
    );
  }
}

class CallCard extends StatelessWidget {
  const CallCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final kpi = {
        "call_card_duration".tr: controller.lastCallModel.value?.callDurationInSeconds != null ? '${controller.lastCallModel.value?.callDurationInSeconds} sn' : '0 sn',
        "call_card_number".tr: controller.lastCallModel.value?.receiverNumber ?? '',
        "call_card_quality".tr: _signalToQuality(controller.lastCallModel.value?.qualityStrengthList),
        "call_card_termination".tr: "termination_reason_user".tr
      };

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.phone, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text('call_card_title'.tr, style: TextStyleUtils.whiteColorBoldText(18, [])),
              const SizedBox(height: 8),
              Text('call_card_desc'.tr, style: TextStyleUtils.whiteColorRegularText(14)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => const CallBottomSheet(),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'call_card_button'.tr,
                      style: TextStyleUtils.generalGilroyBoldText(16, AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Visibility(
                visible: controller.lastCallModel.value != null,
                child: Card(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('call_card_last_info'.tr, style: TextStyleUtils.blackColorBoldText(15)),
                        const SizedBox(height: 8),
                        ...kpi.entries.map((e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key + ':', style: TextStyleUtils.blackColorRegularText(13)),
                                Text(e.value, style: TextStyleUtils.blackColorRegularText(13)),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  static String _signalToQuality(List<int>? level) {
    if (level == null || level.isEmpty) {
      return 'Bilinmiyor';
    }
    final average = level.reduce((a, b) => a + b) ~/ level.length;
    switch (average) {
      case 0:
        return 'call_card_none'.tr;
      case 1:
        return 'weak'.tr;
      case 2:
        return 'call_card_medium'.tr;
      case 3:
        return 'good'.tr;
      case 4:
        return 'very_good'.tr;
      default:
        return 'Bilinmiyor';
    }
  }
}

class CallBottomSheet extends StatefulWidget {
  const CallBottomSheet({super.key});

  @override
  State<CallBottomSheet> createState() => _CallBottomSheetState();
}

class _CallBottomSheetState extends State<CallBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String selectedCountryCode = '+90';

  final List<String> countryCodes = [
    '+90',
    '+1',
    '+44',
    '+49',
    '+33',
    '+971',
    '+966',
    '+7',
    '+81',
    '+86',
  ];

  @override
  void dispose() {
    receiverController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Arama Bilgileri', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedCountryCode,
                  items: countryCodes
                      .map((code) => DropdownMenuItem(
                            value: code,
                            child: Text(code),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountryCode = value!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: receiverController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'receiver_phone'.tr,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Numara giriniz' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'duration_min'.tr,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'enter_duration'.tr : null,
            ),
            const SizedBox(height: 24),
            ButtonUtils.cardButton(
              text: 'start_call'.tr,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final receiver = selectedCountryCode + receiverController.text.trim();
                  final duration = int.tryParse(durationController.text.trim()) ?? 0;
                  await FlutterPhoneDirectCaller.callNumber(receiver);
                  controller.startCallTimer(duration, receiver, context);
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class SmsCard extends StatelessWidget {
  const SmsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.sms, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('send_message'.tr, style: TextStyleUtils.blackColorBoldText(18)),
            const SizedBox(height: 8),
            Text('click_to_send_sms'.tr, style: TextStyleUtils.blackColorRegularText(14)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => const SmsBottomSheet(),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'send'.tr,
                    style: TextStyleUtils.generalGilroyBoldText(16, Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmsBottomSheet extends StatefulWidget {
  const SmsBottomSheet({super.key});

  @override
  State<SmsBottomSheet> createState() => _SmsBottomSheetState();
}

class YoutubeCard extends StatelessWidget {
  const YoutubeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('youtube_card_title'.tr, style: TextStyleUtils.blackColorBoldText(15)),
                  const SizedBox(height: 4),
                  Text('youtube_card_desc'.tr, style: TextStyleUtils.blackColorRegularText(13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.youtubeUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Youtube URL',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          controller: controller.youtubeVolumeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'MB',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Align(
              child: GestureDetector(
                onTap: () {
                  controller.startYoutubeStreaming(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmsBottomSheetState extends State<SmsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String selectedCountryCode = '+90';

  final List<String> countryCodes = [
    '+90',
    '+1',
    '+44',
    '+49',
    '+33',
    '+971',
    '+966',
    '+7',
    '+81',
    '+86',
  ];

  @override
  void dispose() {
    receiverController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('sms_send'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedCountryCode,
                  items: countryCodes
                      .map((code) => DropdownMenuItem(
                            value: code,
                            child: Text(code),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountryCode = value!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: receiverController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Alıcı Telefon Numarası',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Numara giriniz' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: messageController,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'message_content'.tr,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Mesaj giriniz' : null,
            ),
            const SizedBox(height: 24),
            ButtonUtils.cardButton(
              text: 'sms_send'.tr,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final receiver = selectedCountryCode + receiverController.text.trim();
                  final message = messageController.text.trim();
                  await controller.sendSms(receiver, message, context);
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
