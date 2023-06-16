import 'package:al_ameen/allUsers_page.dart';
import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/login_page.dart';
import 'package:al_ameen/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisSize: MainAxisSize.max,
              children: [
                // UserAccountsDrawerHeader(
                //     currentAccountPicture: CircleAvatar(
                //       radius: 50,
                //       backgroundColor: Colors.grey.shade300,
                //       child: const Icon(
                //         Icons.person,
                //         size: 50,
                //       ),
                //     ),
                //     accountName: Text('Muees'),
                //     accountEmail: Text('')),
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'Welcome, ${MongoDatabase.name}',
                      style: const TextStyle(fontSize: 30),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  //leading: Icon(Icons.w),
                  title: const Text('All Users'),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllUsersPage(),
                  )),
                ),
                ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () => showDialogBox(context),
                )
              ]),
        ),
      ),
    );
  }

  void showDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Logout ?'),
            content: const Text('Are you sure, You want to logout'),
            contentPadding: const EdgeInsets.all(10),
            actions: [
              TextButton(
                  onPressed: () async{
                    Navigator.pop(context);
                     await FirebaseAuth.instance.signOut();
                     navigatorkey.currentState!.popUntil((route)=> route.isFirst);
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'))
            ], 
          );
        });
  }
}
