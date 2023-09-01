import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/analytics_page/analytics_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

DateTime? selectedFromDate;
DateTime? selectedToDate;
Container buildDatePickerOption(
    BuildContext context, AccountProvider accountProvider) {
  return Container(
    height: 5.h,
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: Row(children: [
      Expanded(
        flex: 2,
        child: TextButton.icon(
          icon: Icon(Icons.date_range, size: 5.w),
          label: Text(
            selectedFromDate != null
                ? accountProvider.aformattedFromDate!
                : 'From Date',
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
          ),
          onPressed: () async {
            selectedFromDate = await datePicker(context);
            accountProvider.asetFromDate(selectedFromDate);
          },
        ),
      ),
      Expanded(
        flex: 2,
        child: TextButton.icon(
          icon: Icon(Icons.date_range, size: 5.w),
          label: Text(
              selectedToDate != null
                  ? accountProvider.aformattedToDate!
                  : 'To Date',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
          onPressed: () async {
            selectedToDate = await datePicker(context);
            accountProvider.asetToDate(selectedToDate);
          },
        ),
      ),
      Expanded(
        flex: 2,
        child: TextButton.icon(
          icon: Icon(Icons.search, size: 5.w),
          label: Text('Search',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
          onPressed: () async {
            if (selectedFromDate != null && selectedToDate != null) {
              accountProvider.getAllAccountsData(
                  start: accountProvider.afromDate,
                  end: accountProvider.atoDate);
              accountProvider.getEachEmployeeData(
                  fromDate: accountProvider.afromDate,
                  toDate: accountProvider.atoDate);
            }
            flag = false;
          },
        ),
      ),
    ]),
  );
}

Future<DateTime?> datePicker(BuildContext context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now());
}
