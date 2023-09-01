import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/profile_page/all_users_page.dart';
import 'package:al_ameen/ui/views/profile_page/components/logout_dialogbox.dart';
import 'package:al_ameen/ui/views/profile_page/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final accountkey = GlobalKey<ScaffoldState>();

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    provider.getUsername();
    return Scaffold(
      key: accountkey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              color: Colors.blue,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 5.h,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 6.h,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.username ?? '',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'RobotoCondensed'),
                      ),
                      Text(
                        'Staff Member',
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey.shade300,
                            fontFamily: 'RobotoCondensed'),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            ListTile(
              title: Text(
                'All Users',
                style:
                    TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
              ),
              trailing: Icon(Icons.keyboard_arrow_right, size: 5.w),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const AllUsersPage();
                },
              )),
            ),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            ListTile(
              title: Text('Contact',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
              trailing: Icon(Icons.contacts, size: 5.w),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ContactsPage(),
              )),
            ),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed', fontSize: 11.sp)),
              trailing: Icon(Icons.logout, size: 5.w),
              onTap: () => showDialogBox(context),
            ),
            SizerUtil.deviceType == DeviceType.tablet
                ? SizedBox(
                    height: 3.h,
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            Divider(
              thickness: 1.sp,
            ),
          ]),
        ),
      ),
    );
  }
}
