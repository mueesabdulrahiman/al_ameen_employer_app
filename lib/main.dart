import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/view_model/account_provider.dart';
import 'package:flutter/material.dart';

import 'package:al_ameen/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await MongoDatabase.connect();
  await FirebaseDB.connect();

  //await MongoDatabase.refreshGetData();

  runApp(const MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();
// final scaffoldkey = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountProvider>(
      create: (_) => AccountProvider(),
      child: MaterialApp(
        navigatorKey: navigatorkey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //scaffoldBackgroundColor: Colors.black,
        ),
        home: const HomePage(),
      ),
    );
  }
}
