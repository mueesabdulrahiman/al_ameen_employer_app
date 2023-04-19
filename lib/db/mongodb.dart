import 'package:al_ameen/db/constants.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
class MongoDatabase {
  static late Db db;
  static late DbCollection userColl;

  static ValueNotifier<List<AccountDetails>> accountListNotifier =
      ValueNotifier([]);

  static connect() async {
    try {
      final db = await Db.create(databaseConnect);
      db.open();
      inspect(db);
      userColl = db.collection(userCollection);
    } catch (e) {
      log("error: $e");
    }
  }

  static Future<String> insert(AccountDetails model) async {
    try {
      var result = await userColl.insertOne(model.toJson());
      if (result.isSuccess) {
        return 'data inserted';
      } else {
        return 'something went wrong';
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<AccountDetails>> getData() async {
    List<AccountDetails> data = [];
    try {
      final result = await userColl.find().toList();
      if (result.isNotEmpty) {
        data = result.map((e) => AccountDetails.fromJson(e)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  Future<void> refreshUI() async {
    final list = await getData();
    accountListNotifier.value.clear();
    accountListNotifier.value.addAll(list);
   // accountListNotifier.notifyListeners();
  }

  static Future<List<AccountDetails>> searchData(
      {required DateTime start,
      required DateTime end,
      required String type}) async {
    final startDate = DateFormat('dd-MM-yyyy').format(start);

    final endDate = DateFormat('dd-MM-yyyy').format(end);

    var query = where
        .gte('date', startDate)
        .lte('date', endDate)
        .eq('type', type.toLowerCase());

    var result = await userColl.find(query).toList();
    final data = result.map((e) => AccountDetails.fromJson(e)).toList();
    return data;
  }
}
