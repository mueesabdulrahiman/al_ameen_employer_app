import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BuildAnalyticsDashboard extends StatelessWidget {
  const BuildAnalyticsDashboard(this.context, this.netIncome, this.netExpense,
      {super.key});
  final BuildContext context;
  final int netIncome;
  final int netExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      // MediaQuery.of(context).size.width < 500
      //     ? MediaQuery.of(context).size.height * 0.10
      //     : MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 1,
          child: _buildDashboardSection('Net Income', netIncome),
        ),
        const SizedBox(
          child: VerticalDivider(
            thickness: 2,
          ),
        ),
        Expanded(
          flex: 1,
          child:
              _buildDashboardSection('Net Balance', (netIncome - netExpense)),
        ),
        const SizedBox(
          child: VerticalDivider(
            thickness: 2,
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildDashboardSection('Net Expense', netExpense),
        ),
      ]),
    );
  }
}

Widget _buildDashboardSection(String label, int value) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 10.sp,
                  letterSpacing: 2.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RobotoCondensed'),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RobotoCondensed',
                  color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
