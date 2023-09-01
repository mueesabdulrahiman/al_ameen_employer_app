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
        padding: EdgeInsets.only(top: isTablet ? 10.sp : 5.sp, left: 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Text('Muees7575@gmail.com',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 12.sp)),
              ],
            )
            // SizedBox(
            //   height: isTablet ? 7.h : 5.h,
            //   child:

            //   ListTile(
            //     contentPadding: EdgeInsets.all(5.sp),
            //     leading: Icon(
            //       Icons.phone,
            //       color: Colors.blue,
            //       size: 15.sp,
            //     ),
            //     title: Text('+91 9048694982',
            //         style: TextStyle(
            //             fontFamily: 'RobotoCondensed', fontSize: 12.sp)),
            //   ),
            // ),
            // SizedBox(
            //   height: isTablet ? 7.h : 5.h,
            //   child: ListTile(
            //     contentPadding: EdgeInsets.all(5.sp),
            //     leading: Icon(
            //       Icons.mail,
            //       color: Colors.blue,
            //       size: 15.sp,
            //     ),
            //     title: Text('Muees7575@gmail.com',
            //         style: TextStyle(
            //             fontFamily: 'RobotoCondensed', fontSize: 12.sp)),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}
