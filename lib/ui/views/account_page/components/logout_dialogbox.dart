import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/ui/views/login_page/login_page.dart';
import 'package:al_ameen/ui/views/account_page/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showDialogBox(BuildContext context) {
  final double titleFontSize = 15.sp;
  final double contentFontSize = 12.sp;
  final double contentPadding = 10.sp;
  final double buttonFontSize = 12.sp;
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Logout?',
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
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await FirebaseAuth.instance.signOut();

                  sharedPreferencesServices.setLogout();
                  Navigator.of(accountkey.currentContext!).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(sharedPreferencesServices),
                      ),
                      (route) => false);
                },
                child: Text('Yes',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: buttonFontSize))),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                    elevation: MaterialStateProperty.all(1.0)),
                onPressed: () => Navigator.pop(context),
                child: Text('No',
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: buttonFontSize)))
          ],
        );
      });
}
