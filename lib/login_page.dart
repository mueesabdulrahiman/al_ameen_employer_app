
import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/home_page.dart';
import 'package:al_ameen/model/login_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

final scaffoldKey = GlobalKey<ScaffoldState>();

class _MyWidgetState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'username should not be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password should not be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await _login();
                        },
                        child: const Text('Login')),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      final user =
          Login(usernameController.text.trim(), passwordController.text.trim());
      UserCredential? result = await FirebaseDB.signInUser(user, context);
      

      if (result?.user?.email != null) {
        Navigator.pushReplacement(
            scaffoldKey.currentContext!,
            MaterialPageRoute(
              builder: (context) =>  HomePage(),
            ));
        usernameController.clear();
        passwordController.clear();
      } else {
        showDialog(
            context: scaffoldKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Authentication Failed'),
                  content: const Text('Invalid username or password.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]);
            });
      }
    }
  }
}
