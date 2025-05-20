import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/presentation/home/controller/home_controller.dart';
import 'package:telephony_rakuten_assignment/presentation/home/widgets/call_bottom_sheet_widget.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';
import 'package:fl_chart/fl_chart.dart';

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
                child: GestureDetector(
                  onTap: () {
                    final qualityList = controller.lastCallModel.value?.qualityStrengthList ?? [];
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: 350,
                          height: 300,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Arama Kalitesi', style: TextStyleUtils.blackColorBoldText(16)),
                              const SizedBox(height: 16),
                              Expanded(
                                child: qualityList.isNotEmpty
                                    ? LineChart(
                                        LineChartData(
                                          minX: 0,
                                          maxX: (qualityList.length - 1).toDouble(),
                                          minY: 0,
                                          maxY: 5,
                                          titlesData: FlTitlesData(
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                            ),
                                            rightTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            topTitles: AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                          ),
                                          gridData: FlGridData(show: true),
                                          borderData: FlBorderData(show: true),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: List.generate(
                                                qualityList.length,
                                                (i) => FlSpot(i.toDouble(), qualityList[i].toDouble()),
                                              ),
                                              isCurved: true,
                                              color: AppColors.primary,
                                              barWidth: 3,
                                              dotData: FlDotData(show: false),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(child: Text('Veri yok')),
                              ),
                              const SizedBox(height: 8),
                              Text('X: Süre (sn), Y: Kalite (0-5)', style: TextStyleUtils.blackColorRegularText(12)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
