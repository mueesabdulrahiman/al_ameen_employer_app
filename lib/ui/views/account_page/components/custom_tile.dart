import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Padding customListTile(List<String> formattedData) {
  return Padding(
    padding: EdgeInsets.only(
        bottom: SizerUtil.deviceType == DeviceType.mobile ? 0.h : 3.h),
    child: ListTile(
      leading: CircleAvatar(
          radius: SizerUtil.deviceType == DeviceType.mobile ? 4.w : 5.w,
          child: Center(
            child: Icon(
              Icons.person,
              size: SizerUtil.deviceType == DeviceType.mobile ? 5.w : 3.5.w,
            ),
          )),
      title: Text(formattedData[0],
          style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp)),
      subtitle: Text(
        formattedData[1],
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 10.sp,
        ),
      ),
    ),
  );
}
