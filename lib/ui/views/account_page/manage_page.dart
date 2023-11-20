import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/account_page/components/custom_tile.dart';
import 'package:al_ameen/ui/views/account_page/components/date_field.dart';
import 'package:al_ameen/ui/views/account_page/components/manage_chair_dialogbox.dart';
import 'package:al_ameen/ui/views/account_page/components/showmodalsheet.dart';
import 'package:al_ameen/ui/views/account_page/components/showToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final _formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class ManagePage extends StatelessWidget {
  ManagePage({super.key});
  String? chair;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.displayChairs();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: SizerUtil.deviceType == DeviceType.tablet
              ? IconThemeData(size: 10.sp)
              : null,
          title: Text(
            'Manage',
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 13.sp),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: SizerUtil.deviceType == DeviceType.tablet
              ? EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h)
              : EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(children: [
            ListTile(
                title: Text(
                  'Users',
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp),
                ),
                trailing: Icon(Icons.keyboard_arrow_right, size: 5.w),
                onTap: () {
                  provider.getAllUsersList();
                  openModalWidget(
                    context,
                    provider: provider,
                    widget: _buildAllUsersViewWidget(),
                  );
                }),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            ListTile(
                title: Text(
                  'Chairs',
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp),
                ),
                trailing: Icon(Icons.keyboard_arrow_right, size: 5.w),
                onTap: () => openModalWidget(
                      context,
                      provider: provider,
                      widget: _buildManageChairsWidget(context, provider),
                    )),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            ListTile(
                title: Text(
                  'Bulk Data',
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp),
                ),
                trailing: Icon(Icons.keyboard_arrow_right, size: 5.w),
                onTap: () {
                  fromDateController = TextEditingController();
                  toDateController = TextEditingController();
                  openModalWidget(context,
                      provider: provider,
                      widget: _buildDeleteBulkDataWidget(context, provider));
                }),
          ]),
        )));
  }

  Form _buildDeleteBulkDataWidget(
      BuildContext context, AccountProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete Bulk Data',
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'RobotoCondensed',
                color: Colors.blue),
          ),
          SizedBox(height: 3.h),
          dateField(context, fromDateController, labelText: 'Enter From Date',
              onTap: () async {
            pickedFromDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year, 1, 1),
                lastDate: DateTime(DateTime.now().year, 12, 31));

            if (pickedFromDate != null) {
              final formattedDate = DateTime(pickedFromDate!.year,
                  pickedFromDate!.month, pickedFromDate!.day);
              fromDateController.text =
                  DateFormat('dd-MM-yyyy').format(formattedDate);
            }
          }),
          SizedBox(height: 1.h),
          dateField(context, toDateController, labelText: 'Enter To Date',
              onTap: () async {
            pickedToDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year, 1, 1),
                lastDate: DateTime(DateTime.now().year, 12, 31));

            if (pickedToDate != null) {
              final formattedDate = DateTime(
                  pickedToDate!.year, pickedToDate!.month, pickedToDate!.day);
              toDateController.text =
                  DateFormat('dd-MM-yyyy').format(formattedDate);
            }
          }),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    provider.deleteMultipleData(context,
                        startDate: pickedFromDate!, endDate: pickedToDate!);
                    Navigator.pop(context);

                    showToastMessage('Data deleted Successfully', false);
                    fromDateController.clear();
                    toDateController.clear();
                  }
                },
                padding: SizerUtil.deviceType == DeviceType.mobile
                    ? EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp)
                    : EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.sp),
                        bottomLeft: Radius.circular(8.sp))),
                child: Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: 'RobotoCondensed'),
                ),
              ),
              MaterialButton(
                padding: SizerUtil.deviceType == DeviceType.mobile
                    ? EdgeInsets.symmetric(horizontal: 4.sp, vertical: 2.sp)
                    : EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                onPressed: () {
                  fromDateController.clear();
                  toDateController.clear();
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.sp),
                        bottomRight: Radius.circular(8.sp))),
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.sp,
                      fontFamily: 'RobotoCondensed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildManageChairsWidget(
      BuildContext context, AccountProvider provider) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Manage Chairs',
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'RobotoCondensed',
                color: Colors.blue),
          ),
          SizedBox(height: 3.h),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              dialogBox(context, true, provider, chair);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: Text(
                'Add Chair',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontFamily: 'RobotoCondensed'),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          const Divider(),
          SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();

              dialogBox(context, false, provider, chair);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: Text(
                'Delete Chair',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontFamily: 'RobotoCondensed'),
              ),
            ),
          )
        ]);
  }

  Consumer<AccountProvider> _buildAllUsersViewWidget() {
    return Consumer<AccountProvider>(builder: (context, state, _) {
      if (state.allUsersList.isEmpty) {
        return Text(
          'No Users',
          style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp),
        );
      } else if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Users',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'RobotoCondensed',
                  color: Colors.blue),
            ),
            Column(
              children: state.allUsersList.map((data) {
                final formattedData = data.split("-");

                return customListTile(formattedData);
              }).toList(),
            ),
          ],
        );
      }
    });
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
