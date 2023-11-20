import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/ui/views/splash_screen_page.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccountProvider>(
          create: (_) {
            final repo =
                AccountProvider(firebaseRepo, sharedPreferencesServices);
            repo.getAccountsData();
            return repo;
          },
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(firebaseRepo),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            key: const Key('material-app'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blue,
              useMaterial3: false,
              inputDecorationTheme: InputDecorationTheme(
                errorStyle: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.red,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ),
            home: SpalshScreenPage(sharedPreferencesServices),
          );
        },
      ),
    );
  }
}
