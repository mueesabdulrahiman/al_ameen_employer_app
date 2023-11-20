import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class FirebaseRepository {
  // connection
  Future<void> connect();
  // authentication
  Future signInUser(Login login, BuildContext context);
  // data crud
  Future<void> insert(Data model);
  Future getData();
  Future getAllUsers();
  Future<void> deleteData(String id);
  Future<List<Data>> searchData(
      {required DateTime start, required DateTime end, String? type});
  Future getEachEmployeeData({DateTime? fromDate, DateTime? toDate});
  Future getDashBoardData({DateTime? fromDate, DateTime? toDate});
  // delete multiple data
  Future<void> deleteMultipleData(BuildContext context,
      {required DateTime start, required DateTime end});
  // chairs crud
  Future<void> insertChair(String? chair);
  Future<void> deleteChair(String id);
  Future getChairs();
}

class FirebaseRepositoryImplementation implements FirebaseRepository {
  @override
  Future<void> connect() async {
    await Firebase.initializeApp();
  }

  @override
  Future<void> deleteData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.delete();
  }

  @override
  Future getAllUsers() async {
    Set<String> users = {};
    try {
      final collections = FirebaseFirestore.instance.collection('accounts');
      final querySnapshot = await collections.get();
      users = querySnapshot.docs.map((doc) {
        final name = doc.data()['name'];
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

    return seperateListsByName(
        employees is Success ? employees.response as List<Data> : employees);
  }

  // normal function
  Map<String, List<Data>> seperateListsByName(List<Data> employees) {
    Map<String, List<Data>> eachEmployeesData = {};
    if (employees.isNotEmpty) {
      for (final employee in employees) {
        if (eachEmployeesData.containsKey(employee.chair)) {
          eachEmployeesData[employee.chair]!.add(employee);
        } else {
          eachEmployeesData[employee.chair] = [employee];
        }
      }
    }
    return eachEmployeesData;
  }

  @override
  Future<void> insert(Data? model) async {
    if (model != null) {
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
  }

  @override
  Future<List<Data>> searchData(
      {required DateTime start, required DateTime end, String? type}) async {
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

  @override
  Future signInUser(Login login, BuildContext context) async {
    final navigator = Navigator.of(context);
    final provider = Provider.of<LoginProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${login.username}@gmail.com", password: login.password);

      navigator.pop();
      final user = result.user!.email!;
      return Success(response: user, code: 200);
    } on FirebaseAuthException catch (e) {
      provider.setFailure(true);
      navigator.pop();
      return Failure(code: 404, response: e.message ?? 'something went wrong');
    }
  }

  // chairs crud operation

  @override
  Future<void> insertChair(String? chair) async {
    if (chair != null) {
      try {
        FirebaseFirestore.instance
            .collection('chairs')
            .doc()
            .set({'name': chair});
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Future<bool> deleteChair(String chairname) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chairs')
        .where('name', isEqualTo: chairname)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentToDelete = querySnapshot.docs.first;
      await FirebaseFirestore.instance
          .collection('chairs')
          .doc(documentToDelete.id)
          .delete();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future getChairs() async {
    List<String> chairs = [];

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('chairs').get();
      for (final document in querySnapshot.docs) {
        final data = document.data();
        chairs.add(data['name']);
      }
      return Success(response: chairs, code: 200);
    } on FirebaseException catch (e) {
      return Failure(code: 404, response: e.message.toString());
    }
  }

  @override
  Future<void> deleteMultipleData(BuildContext context,
      {required DateTime start, required DateTime end}) async {
    final navigator = Navigator.of(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
              child: CircularProgressIndicator(),
            ));
    var query = FirebaseFirestore.instance
        .collection('users')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end.add(const Duration(days: 1)));
    final querySnapshot = await query.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    navigator.pop();
  }
}
