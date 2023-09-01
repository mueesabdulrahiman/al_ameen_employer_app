import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/analytics_page/components/dashboard.dart';
import 'package:al_ameen/ui/views/analytics_page/components/date_selector.dart';
import 'package:al_ameen/ui/views/analytics_page/components/employee_pageview.dart';
import 'package:al_ameen/ui/views/analytics_page/components/linechart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

late bool flag;

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    selectedFromDate = null;
    selectedToDate = null;
    flag = false;
  }

  @override
  void dispose() {
    selectedFromDate = null;
    selectedToDate = null;
    super.dispose();
  }

  void _initialLoadData(AccountProvider accountProvider) {
    if (flag == false && selectedFromDate == null && selectedToDate == null) {
      accountProvider.getAllAccountsData();
      accountProvider.getEachEmployeeData();
      flag = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    _initialLoadData(accountProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer<AccountProvider>(builder: (context, state, _) {
              int netIncome = 0;
              int netExpense = 0;
              List<Data> documents = state.getAllData;
              for (final document in documents) {
                if (document.type == 'income') {
                  netIncome += int.tryParse(document.amount) ?? 0;
                } else {
                  netExpense += int.tryParse(document.amount) ?? 0;
                }
              }
              return BuildAnalyticsDashboard(context, netIncome, netExpense);
            }),

            // date selector
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0.sp),
                children: [
                  buildDatePickerOption(context, accountProvider),
                  SizedBox(
                    height: 10.sp,
                  ),
                  buildEmployeeSideHeading(),
                  SizedBox(
                    height: 5.sp,
                  ),

                  // each employee data card

                  SizedBox(
                    height: 28.h,
                    // MediaQuery.of(context).size.width < 500
                    //     ? MediaQuery.of(context).size.height * 0.3
                    //     : MediaQuery.of(context).size.width * 0.25,
                    child: Consumer<AccountProvider>(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            employeeCardTextStyle('Type'),
                            employeeCardTextStyle('Paid Offline'),
                            employeeCardTextStyle('Paid Online'),
                            employeeCardTextStyle('Total'),
                          ],
                        ),
                      ),
                      builder: (context, state, child) {
                        Map<String, List<Data>> data = state.employersData;
                        if (data.isNotEmpty) {
                          return EmployeePageViewBuilder(data, child);
                        } else {
                          return Center(
                            child: EmployeePageViewBuilder(null, child),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    height: 10.sp,
                  ),

                  buildlineChartSideHeading(),
                  SizedBox(
                    height: 5.sp,
                  ),

                  //  Linechart data

                  Consumer<AccountProvider>(builder: (context, state, _) {
                    final data = state.getData;

                    return LineChartAccountData(data);
                  }),
                  SizedBox(
                    height: 30.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text employeeCardTextStyle(String text) {
    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'RobotoCondensed',
            fontSize: 10.sp));
  }

  Widget buildlineChartSideHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Graph Based Data ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
                fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget buildEmployeeSideHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Data of Each Employee ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoCondensed',
              fontSize: 10.sp),
        ),
        Text(
          'Swipe >>',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoCondensed',
              fontSize: 10.sp),
        ),
      ],
    );
  }
}
