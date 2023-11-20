import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
            accountProvider.aformattedFromDate ?? 'From Date',
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
          ),
          onPressed: () async {
            final selectedFromDate = await datePicker(context);
            accountProvider.asetFromDate(selectedFromDate);
          },
        ),
      ),
      Expanded(
        flex: 2,
        child: TextButton.icon(
          icon: Icon(Icons.date_range, size: 5.w),
          label: Text(accountProvider.aformattedToDate ?? 'To Date',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
          onPressed: () async {
            final selectedToDate = await datePicker(context);
            accountProvider.asetToDate(selectedToDate);
          },
        ),
      ),
      Expanded(
        flex: 2,
        child: TextButton.icon(
          label: Text('Search',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
          icon: Icon(Icons.search,
              color: Theme.of(context).primaryColor, size: 5.w),
          onPressed: () async {
            if (accountProvider.afromDate != null &&
                accountProvider.atoDate != null) {
              accountProvider.getAllAccountsData(
                  start: accountProvider.afromDate,
                  end: accountProvider.atoDate);
              accountProvider.getEachEmployeeData(
                  fromDate: accountProvider.afromDate,
                  toDate: accountProvider.atoDate);
            }
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
