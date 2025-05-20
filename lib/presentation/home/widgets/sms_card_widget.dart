import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/presentation/home/widgets/sms_bottom_sheet_widget.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

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

