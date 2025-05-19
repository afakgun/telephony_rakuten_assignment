import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final receiverNumber = ''.obs;
  final duration = ''.obs;
  final volume = ''.obs;
  final messageBody = ''.obs;

  bool get isFormValid =>
      receiverNumber.value.isNotEmpty &&
      duration.value.isNotEmpty &&
      volume.value.isNotEmpty &&
      messageBody.value.isNotEmpty;
}

class WelcomeScreen extends StatelessWidget {
  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'welcome'.tr,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'fill_fields'.tr,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 32),
              _buildTextField(
                label: 'receiver_phone'.tr,
                hint: 'receiver_phone_hint'.tr,
                onChanged: (v) => controller.receiverNumber.value = v,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'call_duration_label'.tr,
                hint: 'call_duration_hint'.tr,
                onChanged: (v) => controller.duration.value = v,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'youtube_volume_label'.tr,
                hint: 'youtube_volume_hint'.tr,
                onChanged: (v) => controller.volume.value = v,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'sms_message_label'.tr,
                hint: 'sms_message_hint'.tr,
                onChanged: (v) => controller.messageBody.value = v,
                keyboardType: TextInputType.text,
                maxLines: 2,
              ),
              Spacer(),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isFormValid
                          ? () {
                              Get.offAllNamed('/home', arguments: {
                                'receiverNumber': controller.receiverNumber.value,
                                'duration': controller.duration.value,
                                'volume': controller.volume.value,
                                'messageBody': controller.messageBody.value,
                              });
                            }
                          : null,
                      child: Text('continue'.tr),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
