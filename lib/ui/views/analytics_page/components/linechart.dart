import 'package:al_ameen/data/models/data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LineChartAccountData extends StatelessWidget {
  const LineChartAccountData(this.documents, {super.key});

  final List<Data>? documents;
  List<FlSpot> getChartDataByMonth(List<Data> documents) {
    List<FlSpot> data = documents.isNotEmpty
        ? List.generate(12, (index) => FlSpot(index.toDouble(), 0.0))
        : <FlSpot>[];
    if (documents.isNotEmpty) {
      for (var document in documents) {
        if (document.date.month >= 1 && document.date.month <= 12) {
          final index = document.date.month - 1;
          final existingSpot = data[index];
          final spotAmount = double.tryParse(document.amount) ?? 0.0;
          final updatedSpot = FlSpot(
              existingSpot.x,
              existingSpot.y +
                  (document.type == 'income' ? spotAmount : -spotAmount));
          data[index] = updatedSpot;
        }
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.sp, 10.sp, 0.sp, 3.sp),
      height: 35.h,
      
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 35, 83),
          borderRadius: BorderRadius.circular(8.sp)),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 100000,
          borderData:
              FlBorderData(border: Border.all(color: const Color(0xff37434d))),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 10000,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: const Color(0xff37434d), strokeWidth: 1.0);
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(color: const Color(0xff37434d), strokeWidth: 1.0);
            },
          ),
          lineBarsData: [
            LineChartBarData(
                spots: getChartDataByMonth(documents ?? []),
                isCurved: false,
                barWidth: 1.sp,
                dotData: FlDotData(
                  show: false,
                ),
                color: const Color.fromARGB(255, 76, 164, 185),
                belowBarData: BarAreaData(
                    show: true,
                    color: const Color.fromARGB(255, 76, 164, 185)
                        .withOpacity(0.2)))
          ],
          titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return buildText('JAN');
                  } else if (value == 2) {
                    return buildText('MAR');
                  } else if (value == 4) {
                    return buildText('MAY');
                  } else if (value == 6) {
                    return buildText('JUL');
                  } else if (value == 8) {
                    return buildText('SEP');
                  } else if (value == 10) {
                    return buildText('NOV');
                  }
                  return const SizedBox();
                },
                reservedSize: 10.sp,
              )),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 20000:
                          return buildText('20k');
                        case 40000:
                          return buildText('40k');
                        case 60000:
                          return buildText('60k');
                        case 80000:
                          return buildText('80k');
                        case 100000:
                          return buildText('100k');
                      }
                      return const SizedBox();
                    },
                    reservedSize: 20.sp),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false))),
        ),
      ),
    );
  }

  Widget buildText(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white, fontFamily: 'RobotoCondensed', fontSize: 8.sp),
    );
  }
}
