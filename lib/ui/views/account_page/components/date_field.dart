import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

DateTime? pickedFromDate;
DateTime? pickedToDate;
TimeOfDay? pickedTime;
DateTime? formattedDate;

late TextEditingController fromDateController;
late TextEditingController toDateController;

TextFormField dateField(BuildContext context, TextEditingController controller,
    {required String labelText, required void Function() onTap}) {
  return TextFormField(
    keyboardType: TextInputType.none,
    controller: controller,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
      filled: true,
      fillColor: Colors.blue.shade100,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: const BorderSide(color: Colors.blue)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: BorderSide(color: Colors.blue.shade700)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.sp),
          borderSide: const BorderSide(color: Colors.red)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Field should not be empty';
      } else {
        return null;
      }
    },
    onTap: () async {
      onTap();
    },
  );
}
