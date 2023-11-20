import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/account_page/components/showToastMessage.dart';
import 'package:al_ameen/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void dialogBox(BuildContext context, bool toCreate, AccountProvider provider,
        String? data) =>
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: toCreate
                ? Text('Add Chair',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 15.sp))
                : Text('Delete Chair',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed', fontSize: 15.sp)),
            content: TextField(
                onChanged: (value) {
                  data = value.toCapitalized();
                },
                decoration: InputDecoration(
                    labelText: toCreate ? 'Enter chair' : 'Delete chair',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp)))),
            contentPadding: EdgeInsets.all(10.sp),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (data != null) {
                      final allChairs = provider.chairs;
                      final deleteData = allChairs.firstWhere(
                        (e) => e == data,
                        orElse: () => 'Nil',
                      );
                      Navigator.pop(context);
                      if (toCreate) {
                        provider.createChair(data!);

                        showToastMessage('Chair created successfully', true);
                      } else if (!toCreate && !deleteData.contains('Nil')) {
                        provider.deleteChair(deleteData);

                        showToastMessage('Chair deleted successfully', false);
                      } else {
                        showToastMessage(
                            'Enter correct chair to delete', false);
                      }
                    }
                  },
                  child: toCreate
                      ? Text('Add',
                          style: TextStyle(
                              fontFamily: 'RobotoCondensed', fontSize: 10.sp))
                      : Text('Delete',
                          style: TextStyle(
                              fontFamily: 'RobotoCondensed', fontSize: 10.sp))),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                      elevation: MaterialStateProperty.all(1.0)),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed', fontSize: 10.sp)))
            ],
          );
        });
