import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/presentation/home/controller/home_controller.dart';
import 'package:telephony_rakuten_assignment/utils/button_utils.dart';
import 'package:telephony_rakuten_assignment/utils/dropdown_utils.dart';

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
                Flexible(
                  child: DropdownUtils.cardDropdown<String>(
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
