import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchFilterBuilder extends StatelessWidget {
  SearchFilterBuilder(this.provider, {super.key});
  final AccountProvider provider;
  final categoryTypes = ['Income', 'Expense', 'Both'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchFilterOption(context, provider),
        const SizedBox(
          height: 10,
        ),
        _buildFilterButtons(context, provider),
      ],
    );
  }

  Row _buildFilterButtons(BuildContext context, AccountProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 5.h,
            // height: MediaQuery.of(context).size.width < 500
            //     ? MediaQuery.of(context).size.height * 0.05
            //     : MediaQuery.of(context).size.width * 0.07,
            child: ElevatedButton(
                onPressed: () async {
                  if (provider.fromDate != null &&
                      provider.toDate != null &&
                      provider.dropDownValue != null) {
                    provider.searchAccountsData(type: provider.dropDownValue);
                    provider.didSearch = true;
                  }
                },
                child: Text('Apply',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 10.sp))),
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 5.h,
            // MediaQuery.of(context).size.width < 500
            //     ? MediaQuery.of(context).size.height * 0.05
            //     : MediaQuery.of(context).size.width * 0.07,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 1,
                ),
                onPressed: () async {
                  provider.resetSearchData();
                },
                child: Text('Clear',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 10.sp))),
          ),
        ),
      ],
    );
  }

  Container buildSearchFilterOption(
      BuildContext context, AccountProvider provider) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: () async {
            final fromDatePicker = await datePicker(context);
            provider.setFromDate(fromDatePicker);
          },
          child: SizedBox(
            child: Center(
              child: Text(
                provider.formattedFromDate ?? 'From Date',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 10.sp),
              ),
            ),
          ),
        )),
        const VerticalDivider(
          color: Colors.black,
        ),
        Expanded(
            child: GestureDetector(
          onTap: () async {
            final toDatePicker = await datePicker(context);
            provider.setToDate(toDatePicker);
          },
          child: SizedBox(
            child: Center(
              child: Text(
                provider.formattedToDate ?? 'To Date ',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 10.sp),
              ),
            ),
          ),
        )),
        const VerticalDivider(
          color: Colors.black,
        ),
        Expanded(
          child: dropDownPicker(provider),
          //  )
        ),
      ]),
    );
  }

  DropdownButtonHideUnderline dropDownPicker(AccountProvider provider) {
    bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        itemHeight: isTablet ? 5.h : 8.h,
        iconEnabledColor: Colors.white,
        iconSize: 16.sp,
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.blue,
        hint: Text('Type',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'RobotoCondensed',
                fontSize: 10.sp)),
        value: provider.dropDownValue,
        items: categoryTypes.map(buildMenuButton).toList(),
        onChanged: (value) {
          provider.setDropDownValue(value);
        },
       
      ),
    );
  }

  DropdownMenuItem<String> buildMenuButton(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 10.sp),
      ),
    );
  }

  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
  }
}
