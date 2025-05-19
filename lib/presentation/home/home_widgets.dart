import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../utils/textstyle_utils.dart';

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
            Text(name ?? 'Kullanıcıya erişilemedi', style: TextStyleUtils.blackColorBoldText(16)),
            Text(phone ?? 'Telefon numarasına erişilemedi', style: TextStyleUtils.blackColorRegularText(14)),
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
        "Call Duration": controller.lastCallModel.value?.callDurationInSeconds != null ? '${controller.lastCallModel.value?.callDurationInSeconds} sn' : '0 sn',
        "Dialed Number": controller.lastCallModel.value?.receiverNumber ?? '',
        "Call Quality": _signalToQuality(controller.lastCallModel.value?.qualityStrengthList),
        "Termination Reason": "Kullanıcı sonlandırdı"
      };

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.phone, size: 48, color: Colors.green[700]),
              const SizedBox(height: 16),
              Text('Arama Yap', style: TextStyleUtils.blackColorBoldText(18)),
              const SizedBox(height: 8),
              Text('Belirli bir numarayı aramak için tıklayın.', style: TextStyleUtils.blackColorRegularText(14)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => const CallBottomSheet(),
                  );
                },
                child: const Text('Ara'),
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
                        Text('Son arama bilgileri', style: TextStyleUtils.blackColorBoldText(15)),
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
        return 'Yok';
      case 1:
        return 'Zayıf';
      case 2:
        return 'Orta';
      case 3:
        return 'İyi';
      case 4:
        return 'Çok İyi';
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
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Süre (dakika)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Süre giriniz' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final receiver = selectedCountryCode + receiverController.text.trim();
                    final duration = int.tryParse(durationController.text.trim()) ?? 0;
                    await FlutterPhoneDirectCaller.callNumber(receiver);
                    controller.startCallTimer(duration, receiver);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Aramayı Başlat'),
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.sms, size: 48, color: Colors.blue[700]),
            const SizedBox(height: 16),
            Text('Mesaj Gönder', style: TextStyleUtils.blackColorBoldText(18)),
            const SizedBox(height: 8),
            Text('SMS göndermek için tıklayın.', style: TextStyleUtils.blackColorRegularText(14)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) => const SmsBottomSheet(),
                );
              },
              child: const Text('Gönder'),
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Youtube Akışı', style: TextStyleUtils.blackColorBoldText(15)),
                  const SizedBox(height: 4),
                  Text('Youtube URL ve veri miktarını girerek başlat.', style: TextStyleUtils.blackColorRegularText(13)),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.red[700],
                ),
                onPressed: () {
                  controller.startYoutubeStreaming();
                },
                child: const Icon(Icons.play_arrow, color: Colors.white),
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
            Text('SMS Gönder', style: Theme.of(context).textTheme.titleLarge),
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
              decoration: const InputDecoration(
                labelText: 'Mesaj İçeriği',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Mesaj giriniz' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final receiver = selectedCountryCode + receiverController.text.trim();
                    final message = messageController.text.trim();
                    await controller.sendSms(receiver, message);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('SMS Gönder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
