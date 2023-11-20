import 'package:al_ameen/data/models/data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmployeePageViewBuilder extends StatelessWidget {
  const EmployeePageViewBuilder(
    this.data,
    this.child, {
    super.key,
  });

  final Map<String, List<Data>>? data;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: data == null ? 1 : data!.length,
        itemBuilder: (context, index) {
          int netIncOffline = 0;
          int netExpOffline = 0;
          int netIncOnline = 0;
          int netExpOnline = 0;
          List<String> empNames = [];
          if (data != null) {
            empNames = data!.keys.toList();
            final values = data!.values.toList();
            final value = values.elementAt(index);
            for (var element in value) {
              if (element.type == 'income') {
                if (element.payment == 'Money') {
                  netIncOffline += int.parse(element.amount);
                } else {
                  netIncOnline += int.parse(element.amount);
                }
              } else if (element.type == 'expense') {
                if (element.payment == 'Money') {
                  netExpOffline += int.parse(element.amount);
                } else {
                  netExpOnline += int.parse(element.amount);
                }
              }
            }
          }

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.sp)),
            child: Column(
              children: [
                ListTile(
                  contentPadding: SizerUtil.deviceType == DeviceType.mobile
                      ? EdgeInsets.symmetric(horizontal: 5.sp, vertical: 0.sp)
                      : EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                  tileColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.sp),
                          topRight: Radius.circular(12.sp))),
                  title: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'RobotoCondensed',
                      fontSize: 12.sp,
                    ),
                  ),
                  trailing: Text(
                    data != null ? empNames.elementAt(index) : 'Nil',
                    style: TextStyle(
                      color: Colors.grey.shade200,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'RobotoCondensed',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                child!,
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Income',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: 10.sp,
                      ),
                    ),
                    builldCountCard(netIncOffline),
                    builldCountCard(netIncOnline),
                    builldCountCard(netIncOnline + netIncOffline),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Expense',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: 10.sp,
                      ),
                    ),
                    builldCountCard(netExpOffline),
                    builldCountCard(netExpOnline),
                    builldCountCard(netExpOffline + netExpOnline),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        });
  }

  Card builldCountCard(int value) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(3.sp),
      child: SizedBox(
        width: 40.sp,
        child: Text(
          value.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 10.sp,
          ),
        ),
      ),
    ));
  }
}
