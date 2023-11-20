import 'package:al_ameen/ui/views/navigation_page/home_page.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/ui/views/login_page/login_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';

class SpalshScreenPage extends StatefulWidget {
  const SpalshScreenPage(this.sharedPref, {super.key});
  final SharedPreferencesServices sharedPref;

  @override
  State<SpalshScreenPage> createState() => _SpalshScreenPageState();
}

class _SpalshScreenPageState extends State<SpalshScreenPage> {
  @override
  void initState() {
    super.initState();
    loadApp();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        key: const Key('splash-screen'),
        child: Image.asset('assets/images/al-ameen-logo.png'),
      ),
    );
  }

  loadApp() async {
    if (await sharedPreferencesServices.checkLoginStatus() != null) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(scaffoldKey.currentContext!,
          MaterialPageRoute(builder: (ctx) => HomePage(widget.sharedPref)));
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
          scaffoldKey.currentContext!,
          MaterialPageRoute(
              builder: (ctx) => LoginPage(sharedPreferencesServices)));
    }
  }
}
