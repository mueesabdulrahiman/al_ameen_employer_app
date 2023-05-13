import 'package:al_ameen/db/constants.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:flutter/material.dart';
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
      await db.open();
      inspect(db);
      userColl = db.collection(userCollection);
    } catch (e) {
      log("error: $e");
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
       
      }
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  static Future<void> refreshUI() async {
    final list = await getData();
    accountListNotifier.value.clear();
    accountListNotifier.value.addAll(list);
    accountListNotifier.notifyListeners();
  }

  static Future<List<AccountDetails>> searchData(
      {required DateTime start,
      required DateTime end,
      required String type}) async {
    // final startDate = DateFormat('dd-MM-yyyy').format(start);

    // final endDate = DateFormat('dd-MM-yyyy').format(end);
    SelectorBuilder query;

    // log('***');
    // log(start.toString());
    // log(end.toString());
    // log('***');

    if (type == 'Both') {
      query = where
          .gte('date', DateTime.utc(start.year, start.month, start.day))
          .lte('date', DateTime.utc(end.year, end.month, end.day));
    } else {
      query = where
          .gte('date', DateTime.utc(start.year, start.month, start.day))
          .lte('date', DateTime.utc(end.year, end.month, end.day))
          .eq('type', type.toLowerCase());
    }
    log(query.toString());
    var result = await userColl.find(query).toList();
    final data = result.map((e) => AccountDetails.fromJson(e)).toList();
    return data;
  }
}
