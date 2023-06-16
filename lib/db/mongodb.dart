import 'package:al_ameen/db/constants.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:al_ameen/model/login_details.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';

class MongoDatabase {
  static late Db db;
  static late DbCollection userColl;
  static late DbCollection authColl;
  static String? _username;
  static String? get name => _username;

  static ValueNotifier<List<AccountDetails>> accountListNotifier =
      ValueNotifier([]);
  static ValueNotifier<List<AccountDetails>> searchedAccountListNotifier =
      ValueNotifier([]);
  static ValueNotifier<Map<String, List<AccountDetails>>>
      searchedEmployeeAccountListNotifier = ValueNotifier({});

  static connect() async {
    try {
      final db = await Db.create(databaseConnect);
      await db.open();
      inspect(db);
      userColl = db.collection(userCollection);
      authColl = db.collection(authCollection);
    } catch (e) {
      log("error: $e");
    }
  }

  static Future<bool> login(Login user) async {
    Map<String, dynamic>? result;
    try {
      result = await authColl
          .findOne({'username': user.username, 'password': user.password});
      if (result != null) {
        _username = user.username;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> insert(AccountDetails model) async {
    try {
      var result = await userColl.insertOne(model.toJson());
      if (result.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<AccountDetails>> getData() async {
    List<AccountDetails> data = [];
    try {
      final result = await userColl.find().toList();
      if (result.isNotEmpty) {
        data = result.map((e) => AccountDetails.fromJson(e)).toList();

        accountListNotifier.value.clear();
        accountListNotifier.value.addAll(data);
        accountListNotifier.notifyListeners();
        //await startChangeStream();
      }
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  // static Future<void> refreshGetData() async {
  //   final list = await getData();
  //   accountListNotifier.value.clear();
  //   accountListNotifier.value.addAll(list);
  //   accountListNotifier.notifyListeners();
  // }

  static Future<List<AccountDetails>> searchData(
      {required DateTime start, required DateTime end, String? type}) async {
    // final startDate = DateFormat('dd-MM-yyyy').format(start);

    // final endDate = DateFormat('dd-MM-yyyy').format(end);
    SelectorBuilder query;

    // log('***');
    // log(start.toString());
    // log(end.toString());
    // log('***');

    if (type == 'Both' || type == null) {
      query = where
          .gte('date', DateTime.utc(start.year, start.month, start.day))
          .lte('date', DateTime.utc(end.year, end.month, end.day));
    } else {
      query = where
          .gte('date', DateTime.utc(start.year, start.month, start.day))
          .lte('date', DateTime.utc(end.year, end.month, end.day))
          .eq('type', type.toLowerCase());
    }
    var result = await userColl.find(query).toList();
    final data = result.map((e) => AccountDetails.fromJson(e)).toList();
    data.sort((a, b) {
      final firstDate = a.date;
      final secondDate = b.date;
      return firstDate.compareTo(secondDate);
    });
    return data;
  }

  Future<void> getEachEmployeeData(
      {DateTime? fromDate, DateTime? toDate}) async {
    final employees = fromDate != null && toDate != null
        ? await MongoDatabase.searchData(start: fromDate, end: toDate)
        : await MongoDatabase.getData();
    searchedEmployeeAccountListNotifier.value.clear();
    searchedEmployeeAccountListNotifier.value
        .addAll(seperateListsByName(employees));
    searchedEmployeeAccountListNotifier.notifyListeners();
    // return seperateListsByName(employees);
  }

  Map<String, List<AccountDetails>> seperateListsByName(
      List<AccountDetails> employees) {
    Map<String, List<AccountDetails>> eachEmployeesData = {};
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
        ? await MongoDatabase.searchData(start: fromDate, end: toDate)
        : await MongoDatabase.getData();
    searchedAccountListNotifier.value.clear();
    searchedAccountListNotifier.value.addAll(allData);
    searchedAccountListNotifier.notifyListeners();
  }

  static Future<void> deleteData(ObjectId key) async {
    await userColl.deleteOne(where.eq('_id', key));
    await getData();
  }

  static Future<void> startChangeStream() async {
    final pipeline = [
      {
        '\$match': {'operationType': 'insert'}
      }
    ];

    final changeStream = userColl.watch(pipeline);
    await for (var change in changeStream) {
      final insertedDocument = change['fullDocument'];
      final accountDetails = AccountDetails.fromJson(insertedDocument);

      // Update the list of account details
      accountListNotifier.value.add(accountDetails);
      accountListNotifier.notifyListeners();
    }
  }
}
