import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact',
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 13.sp)),
        centerTitle: true,
        iconTheme: isTablet ? IconThemeData(size: 10.sp) : null,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(isTablet ? 10.sp : 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(
                child: Divider(color: Colors.grey, thickness: 1),
              ),
              Text('Developer Support',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed', fontSize: 10.sp)),
              const Expanded(
                child: Divider(color: Colors.grey, thickness: 1),
              )
            ]),
            SizedBox(height: 1.h),
            Row(children: [
              Icon(
                Icons.phone,
                color: Colors.blue,
                size: 15.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text('+91 9048694982',
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp))
            ]),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.mail,
                  color: Colors.blue,
                  size: 15.sp,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text('Tech@Prokomers.com',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 12.sp)),
              ],
            )
          ],
        ),
      )),
    );
  }
}
