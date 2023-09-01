import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/data/models/api_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class FirebaseRepository {
  Future<void> connect();
  Future signInUser(Login login, BuildContext context);
  Future<void> insert(Data model);
  Future getData();
  Future getAllUsers();
  Future<void> deleteData(String id);
  Future<List<Data>> searchData({required DateTime start, required DateTime end, String? type});
  Future getEachEmployeeData({DateTime? fromDate, DateTime? toDate});
  Future getDashBoardData({DateTime? fromDate, DateTime? toDate});
}

class FirebaseRepositoryImplementation implements FirebaseRepository {
  @override
  Future<void> connect() async {
    await Firebase.initializeApp();
  }

  @override
  Future<void> deleteData(String id) async  {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.delete();
  }

  @override
  Future getAllUsers() async{
    Set<String> users = {};
    try {
      final collections = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await collections.get();
      users = querySnapshot.docs.map((doc) {
        final name = doc.data()['name'].toString();
        final role = doc.data()['role'];
        return "$name-$role";
      }).toSet();
      return users;
    } on FirebaseException catch (e) {
      return Failure(code: 404, response: e.message.toString());
    }
  }

  @override
  Future getDashBoardData({DateTime? fromDate, DateTime? toDate}) async {
    final allData = fromDate != null && toDate != null
        ? await searchData(start: fromDate, end: toDate)
        : await getData();

    return allData;
  }

  @override
  Future getData() async {
    List<Data> data = [];
    try {
      final collections = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await collections.get();

      data =
          querySnapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();

      return Success(code: 400, response: data);
    } on FirebaseException catch (e) {
      return Failure(code: 404, response: e.message.toString());
    }
  }

  @override
  Future getEachEmployeeData({DateTime? fromDate, DateTime? toDate}) async {
   final employees = fromDate != null && toDate != null
        ? await searchData(start: fromDate, end: toDate)
        : await getData();
    if (employees is Failure) return employees;

    return seperateListsByName(employees is Success
        ? employees.response as List<Data>
        : employees as List<Data>);
  }

  @override
  Future<void> insert(Data model) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc();

      model.id = docUser.id;
      docUser.set(model.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Future<List<Data>> searchData({required DateTime start, required DateTime end, String? type}) async  {
    List<Data> searchResult = [];
    late Query<Map<String, dynamic>> query;
    final collection = FirebaseFirestore.instance.collection('users');

    query = collection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end.add(const Duration(days: 1)));

    final snapshot = await query.get();
    searchResult =
        snapshot.docs.map((doc) => Data.fromJson(doc.data())).toList();

    if (searchResult.isNotEmpty && type != null) {
      if (type == 'Income') {
        searchResult =
            searchResult.where((model) => model.type == 'income').toList();
      } else if (type == 'Expense') {
        searchResult =
            searchResult.where((model) => model.type == 'expense').toList();
      }
      searchResult.sort((a, b) {
        final firstDate = a.date;
        final secondDate = b.date;
        return firstDate.compareTo(secondDate);
      });
    }
    return searchResult;
  }

  // normal function
  Map<String, List<Data>> seperateListsByName(List<Data> employees) {
    Map<String, List<Data>> eachEmployeesData = {};
    if (employees.isNotEmpty) {
      for (final employee in employees) {
        if (eachEmployeesData.containsKey(employee.name)) {
          eachEmployeesData[employee.name]!.add(employee);
        } else {
          eachEmployeesData[employee.name] = [employee];
        }
      }
    }
    return eachEmployeesData;
  }

  @override
  Future signInUser(Login login, BuildContext context) async {
    final navigator = Navigator.of(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${login.username}@gmail.com", password: login.password);

      navigator.pop();
      return user;
    } on FirebaseAuthException catch (e) {
      navigator.pop();
      return Failure(code: 404, response: e.message.toString());
    }
  }
}
