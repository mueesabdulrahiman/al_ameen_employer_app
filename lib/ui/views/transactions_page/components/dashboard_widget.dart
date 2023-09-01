import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Container dashboardContainer(BuildContext context, int income, int expense) {
  return Container(
    height: 30.h,
    //  MediaQuery.of(context).size.width < 500
    //     ? MediaQuery.of(context).size.height * 0.25
    //     : MediaQuery.of(context).size.width * 0.3,
    padding: EdgeInsets.all(10.sp),
    width: double.infinity,

    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400, 
            offset: const Offset(8, 8),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-8, -8),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ]),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'Today\'s Balance',
              style: TextStyle(
                  fontSize: 8.sp,
                  letterSpacing: 2.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'RobotoCondensed'),
            ),
            Text(
              (income - expense).toString(),
              style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                  fontFamily: 'RobotoCondensed'),
            ),
          ],
        ),
        Row(
          children: [
            Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        'Today\'s Income',
                        style: TextStyle(
                            fontSize: 8.sp,
                            letterSpacing: 2.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoCondensed'),
                      ),
                      SizedBox(width: 1.w),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 3.sp,
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 5.0,
                  // ),
                  Text(
                    income.toString(),
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontFamily: 'RobotoCondensed'),
                  ),
                ]),
            const Spacer(),
            Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        'Today\'s Expence',
                        style: TextStyle(
                            fontSize: 8.sp,
                            letterSpacing: 2.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'RobotoCondensed'),
                      ),
                      SizedBox(width: 1.w),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 3.sp,
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 5.0,
                  // ),
                  Text(
                    expense.toString(),
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontFamily: 'RobotoCondensed'),
                  ),
                ]),
          ],
        ),
      ],
    ),
  );
}
