import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/ui/views/splash_screen_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  setupLocator();
  await firebaseRepo.connect();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProvider>(
          create: (_) => AccountProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                errorStyle: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.red,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ),
            home: const SpalshScreenPage(),
          );
        },
      ),
    );
  }
}
