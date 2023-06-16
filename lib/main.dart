import 'package:al_ameen/db/firebasedb.dart';
import 'package:flutter/material.dart';

import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/home_page.dart';
import 'package:al_ameen/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  await FirebaseDB.connect();
  //await MongoDatabase.refreshGetData();

  runApp(const MyApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
