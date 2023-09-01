import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/transactions_page/components/dashboard_widget.dart';
import 'package:al_ameen/ui/views/transactions_page/components/scrollview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(2.w, 0.5.h, 2.w, 0.5.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Consumer<AccountProvider>(
                    builder: (context, state, child) {
                      int income = 0;
                      int expense = 0;
                      var value = state.getData;
                      for (final result in value) {
                        if (result.date.day == DateTime.now().day &&
                            result.date.month == DateTime.now().month) {
                          if (result.type == "income") {
                            income += int.parse(result.amount);
                          } else {
                            expense += int.parse(result.amount);
                          }
                        }
                      }

                      return dashboardContainer(context, income, expense);
                    },
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Expanded(child: Consumer<AccountProvider>(
                    builder: (context, res, _) {
                      final value = res.getData;
                      List<Data> data = [];
                      if (value.isNotEmpty) {
                        DateTime currentDate = DateTime.now();
                        data = value.where((element) {
                          final res = element.date.day == currentDate.day &&
                              element.date.month == currentDate.month;
                          return res == true;
                        }).toList();
                      }
                      if (res.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (data.isNotEmpty) {
                        return ScrollViewBuilder(data: data, constraints: constraints,);
                      } else {
                        return Center(
                          child: Text(
                            'No Data Today',
                            style: TextStyle(
                                fontFamily: 'RobotoCondensed', fontSize: 10.sp),
                          ),
                        );
                      }
                    },
                  )),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
