import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

TextFormField buildDescriptionField(
    TextEditingController? descriptionController, FocusNode node3) {
  return TextFormField(
    controller: descriptionController,
    focusNode: node3,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
    decoration: InputDecoration(
      hintText: 'For ex: haircut',
      hintStyle: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
      labelText: 'Enter Description',
      labelStyle: TextStyle(
          color: Colors.blue.shade700,
          fontFamily: 'RobotoCondensed',
          fontSize: 11.sp),
      filled: true,
      fillColor: Colors.blue.shade100,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red)),
    ),
  );
}

TextFormField buildAmountField(
    TextEditingController amountController, FocusNode node2) {
  return TextFormField(
    controller: amountController,
    focusNode: node2,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
    decoration: InputDecoration(
        hintText: "For ex: 100",
        hintStyle: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
        labelText: 'Enter Amount',
        labelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontFamily: 'RobotoCondensed',
            fontSize: 11.sp),
        filled: true,
        fillColor: Colors.blue.shade100,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red))),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'amount should not be empty';
      } else {
        return null;
      }
    },
  );
}

TextFormField buildDateField(BuildContext context,
    TextEditingController dateController, FocusNode node1) {
  return TextFormField(
    focusNode: node1,
    controller: dateController,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
    decoration: InputDecoration(
      helperText: 'click to choose other date',
      helperStyle: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 9.sp),
      filled: true,
      fillColor: Colors.blue.shade100,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'date should not be empty';
      } else {
        return null;
      }
    },
    onTap: () async {
      pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year, 1, 1),
          lastDate: DateTime(DateTime.now().year, 12, 31));
      pickedTime = const TimeOfDay(hour: 12, minute: 0);

      if (pickedDate != null) {
        formattedDate = DateTime(pickedDate!.year, pickedDate!.month,
            pickedDate!.day, pickedTime!.hour, pickedTime!.minute);
        pickedDate?.add(Duration(hours: pickedTime!.hour));
        dateController.text =
            DateFormat('dd-MM-yyyy HH:mm a').format(formattedDate!);
      }
    },
  );
}

ElevatedButton buildSubmitButton(
  BuildContext context,
  AccountProvider provider,
  TextEditingController? descriptionController,
  TextEditingController amountController,
  TextEditingController dateController,
  DateTime? date,
) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 15.sp, fontFamily: 'RobotoCondensed'),
      ),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        final navigator = Navigator.of(
            context); // because buildcontext can't directly call inside async function
        final providerNavigator = Provider.of<AccountProvider>(context,
            listen:
                false); // because buildcontext can't directly call inside async function
        if (formKey.currentState!.validate()) {
          final splittedDate = dateController.text.split(' ');
          final formattedTime = '${splittedDate[1]} ${splittedDate[2]}';
          final formattedDate = pickedDate != null ? date : DateTime.now();

          final category = provider.categoryType == CategoryType.income
              ? 'income'
              : 'expense';
          final paymentMethod =
              provider.onlinePayment ? 'Paid Online' : 'Money';

          final user = await SharedPreferencesServices.checkLoginStatus();

          final formattedUser =
              user![0].substring(0, 1).toUpperCase() + user[0].substring(1);
          final regEx = RegExp(r'[a-zA-Z]+');
          final roleStatus = regEx.stringMatch(user[1]);

          final model = Data(
            name: formattedUser,
            role: roleStatus ?? 'Nil',
            date: formattedDate ?? DateTime.now(),
            time: formattedTime,
            amount: amountController.text,
            description: descriptionController?.text,
            type: category,
            payment: paymentMethod,
          );
          pickedDate = null;

          providerNavigator.addAccountsData(model);
          providerNavigator.getAccountsData();
          navigator.pop();
        }
      });
}

Widget buildCheckBoxOption(AccountProvider provider) {
  bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

  return Row(
    children: [
      Transform.scale(
        scale: isTablet ? 2.0 : 1.0,
        child: Checkbox(
            value: provider.onlinePayment,
            onChanged: (value) {
              provider.setHasPaidOnline(value ?? false);
            }),
      ),
      SizedBox(
        width: 3.w,
      ),
      Text('Online Payment',
          style: TextStyle(fontSize: 11.sp, fontFamily: 'RobotoCondensed'))
    ],
  );
  //  CheckboxListTile(
  //   controlAffinity: ListTileControlAffinity.leading,
  //   value: provider.onlinePayment,
  //   onChanged: (val) {
  //     provider.setHasPaidOnline(val ?? false);
  //   },
  //   title: Text(
  //     'Online Payment',
  //     style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
  //   ),
  // );
}

Widget buildRadioButtonOption(BuildContext context, AccountProvider provider) {
  bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 0.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: isTablet ? 2.0 : 1.0,
              child: Radio<CategoryType>(
                  value: CategoryType.income,
                  groupValue: provider.categoryType,
                  onChanged: (value) {
                    provider.setCategoryType(value ?? CategoryType.income);
                  }),
            ),
            SizedBox(
              width: 3.w,
            ),
            Text('Income',
                style:
                    TextStyle(fontSize: 11.sp, fontFamily: 'RobotoCondensed')),
          ],
        ),
        SizedBox(
          width: 8.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: isTablet ? 2.0 : 1.0,
              child: Radio<CategoryType>(
                  value: CategoryType.expense,
                  groupValue: provider.categoryType,
                  onChanged: (value) {
                    provider.setCategoryType(value ?? CategoryType.income);
                  }),
            ),
            SizedBox(
              width: 3.w,
            ),
            Text('Expense',
                style:
                    TextStyle(fontSize: 11.sp, fontFamily: 'RobotoCondensed')),
          ],
        ),
      ],
    ),
  );
}
