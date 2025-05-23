import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/presentation/home/controller/home_controller.dart';
import 'package:telephony_rakuten_assignment/utils/button_utils.dart';
import 'package:telephony_rakuten_assignment/utils/dropdown_utils.dart';

class SmsBottomSheet extends StatefulWidget {
  const SmsBottomSheet({super.key});

  @override
  State<SmsBottomSheet> createState() => _SmsBottomSheetState();
}

class _SmsBottomSheetState extends State<SmsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  String selectedCountryCode = '+1';

  final List<String> countryCodes = [
    '+1',
    '+90',
    '+44',
    '+49',
    '+33',
    '+971',
    '+966',
    '+7',
    '+81',
    '+86',
    '+994',
    '+62',
    '+63',
    '+65',
    '+66',
    '+81',
    '+82',
    '+84',
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
                Expanded(
                  flex: 1,
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
                  flex: 3,
                  child: TextFormField(
                    controller: receiverController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'receiver_phone_number'.tr,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'enter_number'.tr : null,
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
              validator: (v) => v == null || v.isEmpty ? 'enter_message'.tr : null,
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
