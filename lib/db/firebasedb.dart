import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:al_ameen/main.dart';
import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/model/login_details.dart';

class FirebaseDB {
  static ValueNotifier<List<Data>> accountListNotifier = ValueNotifier([]);
  static ValueNotifier<List<Data>> searchedAccountListNotifier =
      ValueNotifier([]);
  static ValueNotifier<Map<String, List<Data>>>
      searchedEmployeeAccountListNotifier = ValueNotifier({});

  static Future connect() async {
    await Firebase.initializeApp();
  }

  static Future signInUser(Login login, BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '${login.username}@gmail.com', password: login.password);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorkey.currentState!.popUntil((route)=> route.isFirst);
  }

  static Future<void> insert(Data model) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc();

      //final json = {'name': 'muees', 'age': 24, 'date': DateTime(2023, 6, 9)};
      model.id = docUser.id;
      docUser.set(model.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<List<Data>> getData2() async {
    List<Data> data = [];
    final collections = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await collections.get();
    accountListNotifier.value.clear();

    data = querySnapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();
    accountListNotifier.value.clear();
    accountListNotifier.value.addAll(data);
    accountListNotifier.notifyListeners();

    return data;
  }

  static Stream<List<Data>> getData() {
    final collections = FirebaseFirestore.instance.collection('users');

    log("stream");

    return collections.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Data.fromJson(doc.data())).toList());
  }

  static Future<void> deleteData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    docUser.delete();
  }

  static Future<List<Data>> searchData(
      {required DateTime start, required DateTime end, String? type}) async {
    List<Data> searchResult = [];

    late Query<Map<String, dynamic>> query;
    final collection = FirebaseFirestore.instance.collection('users');

    query = collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end.add(const Duration(days: 1)));

    // if (type.toLowerCase() == 'income' || type.toLowerCase() == 'expense') {
    //   query = query.where('type', isEqualTo: type.toLowerCase());
    // snapshot = await collection
    //     .where('date', isGreaterThanOrEqualTo: start)
    //     .where('date', isLessThan: end.add(const Duration(days: 1)))
    //     .where('type', isEqualTo: type.toLowerCase())
    //     .get();
    // }

    final snapshot = await query.get();
    searchResult =
        snapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();

    if (type != null) {
      if (type == 'Income') {
        searchResult =
            searchResult.where((model) => model.type == 'income').toList();
      } else if (type == 'Expense') {
        searchResult =
            searchResult.where((model) => model.type == 'expense').toList();
      }
    }

    log(searchResult.toString());
    searchResult.sort((a, b) {
      final firstDate = a.date;
      final secondDate = b.date;
      return firstDate.compareTo(secondDate);
    });
    return searchResult;
  }

  Future<void> getEachEmployeeData(
      {DateTime? fromDate, DateTime? toDate}) async {
    final employees = fromDate != null && toDate != null
        ? await FirebaseDB.searchData(start: fromDate, end: toDate)
        : await FirebaseDB.getData2();
    searchedEmployeeAccountListNotifier.value.clear();
    searchedEmployeeAccountListNotifier.value
        .addAll(seperateListsByName(employees));
    searchedEmployeeAccountListNotifier.notifyListeners();
  }

  Map<String, List<Data>> seperateListsByName(List<Data> employees) {
    Map<String, List<Data>> eachEmployeesData = {};
    for (final employee in employees) {
      if (eachEmployeesData.containsKey(employee.name)) {
        eachEmployeesData[employee.name]!.add(employee);
      } else {
        eachEmployeesData[employee.name] = [employee];
      }
    }
    return eachEmployeesData;
  }

  Future<void> getDashBoardData({DateTime? fromDate, DateTime? toDate}) async {
    final allData = fromDate != null && toDate != null
        ? await FirebaseDB.searchData(start: fromDate, end: toDate)
        : await FirebaseDB.getData2();
    searchedAccountListNotifier.value.clear();
    searchedAccountListNotifier.value.addAll(allData);
    searchedAccountListNotifier.notifyListeners();
  }
}
