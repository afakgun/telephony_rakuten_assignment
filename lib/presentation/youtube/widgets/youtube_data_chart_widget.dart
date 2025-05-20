import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/controller/youtube_player_controller.dart';

class YoutubeDataChartWidget extends StatelessWidget {
  const YoutubeDataChartWidget({
    super.key,
    required this.controller,
  });

  final YoutubePlayerGetxController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.greyBar,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => LineChart(
            LineChartData(
              backgroundColor: AppColors.greyBar,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 50,
                verticalInterval: 5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: (() {
                      final list = controller.downloadSpeedList;
                      if (list.isEmpty) return 1.0;
                      final min = list.reduce((a, b) => a < b ? a : b);
                      final max = list.reduce((a, b) => a > b ? a : b);
                      final diff = (max - min).abs();
                      if (diff == 0) return 1.0;
                      return (diff / 4).ceilToDouble();
                    })(),
                    getTitlesWidget: (value, meta) {
                      final list = controller.downloadSpeedList;
                      if (list.isEmpty) return const SizedBox.shrink();
                      final min = list.reduce((a, b) => a < b ? a : b);
                      final max = list.reduce((a, b) => a > b ? a : b);
                      final diff = (max - min).abs();
                      final interval = diff == 0 ? 1 : (diff / 4).ceil();
                      List<int> labels;
                      if (diff == 0) {
                        labels = List.filled(5, min);
                      } else {
                        labels = List.generate(5, (i) => min + i * interval);
                        labels[4] = max;
                      }
                      final show = labels.any((label) => (value - label).abs() < 1);
                      if (!show) return const SizedBox.shrink();
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('KB/s', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                  axisNameSize: 24,
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 5,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  axisNameWidget: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('second'.tr, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  ),
                  axisNameSize: 24,
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black12, width: 1),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    controller.downloadSpeedList.length,
                    (i) => FlSpot(
                      i.toDouble(),
                      controller.downloadSpeedList[i].toDouble(),
                    ),
                  ),
                  isCurved: true,
                  color: AppColors.green,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.green.withOpacity(0.12),
                  ),
                ),
              ],
              minY: 0,
            ),
          ),
        ));
  }
}
