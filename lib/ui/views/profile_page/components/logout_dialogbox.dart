import 'package:al_ameen/utils/shared_preference.dart';
import 'package:al_ameen/ui/views/login_page/login_page.dart';
import 'package:al_ameen/ui/views/profile_page/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showDialogBox(BuildContext context) {
  final double titleFontSize = 12.sp;
  final double contentFontSize = 10.sp;
  final double contentPadding = 10.sp;
  final double buttonFontSize = 12.sp;
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Logout ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'RobotoCondensed', fontSize: titleFontSize)),
          content: Text('Are you sure, You want to logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'RobotoCondensed', fontSize: contentFontSize)),
          contentPadding: EdgeInsets.all(contentPadding),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await FirebaseAuth.instance.signOut();

                  SharedPreferencesServices.setLogout();
                  Navigator.of(accountkey.currentContext!).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false);
                },
                child: Text('Yes',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: buttonFontSize))),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: buttonFontSize)))
          ],
        );
      });
}
