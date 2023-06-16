import 'dart:developer';

import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:al_ameen/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  DateTime? datePicker;

  String? formattedFromDate;
  String? formattedDueDate;
  List<String> categoryTypes = ['income', 'expense'];
  String? selectedType;

  @override
  void initState() {
    super.initState();
    FirebaseDB.getData2();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseDB.getData2();
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: FirebaseDB.accountListNotifier,
                builder: (context, value, _) {
                  int income = 0;
                  int expense = 0;

                  for (final result in value) {
                    if (result.date.day == DateTime.now().day &&
                        result.date.month == DateTime.now().month) {
                      if (result.type == "income") {
                        income += int.parse(result.amount);
                      } else {
                        expense += int.parse(result.amount);
                      }
                    }
                  }

                  return Container(
                    height: 200,
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: const Offset(8, 8),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-8, -8),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Today\'s Balance',
                          style: TextStyle(
                              fontSize: 10.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                        Text(
                          (income - expense).toString(),
                          style: const TextStyle(
                              fontSize: 50.0, color: Colors.white),
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Today\'s Income',
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            letterSpacing: 2.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 5),
                                      CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    income.toString(),
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ]),
                            const Spacer(),
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Today\'s Expence',
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            letterSpacing: 2.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 5),
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    expense.toString(),
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ]),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: FutureBuilder<List<Data>>(
                    future: FirebaseDB.getData2(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final value = snapshot.data!;
                        log('hasData');
                        log(value.toString());

                        List<Data> data = [];

                        if (value.isNotEmpty) {
                          DateTime currentDate = DateTime.now().toUtc();
                          data = value.where((element) {
                            final res = element.date.day == currentDate.day &&
                                element.date.month == currentDate.month;
                            return res == true;
                          }).toList();
                        }
                        return (data.isNotEmpty)
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  return Material(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Slidable(
                                        startActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          children: [
                                            SlidableAction(
                                                icon: Icons.delete,
                                                onPressed: (context) {
                                                  FirebaseDB.deleteData(
                                                      index.toString());
                                                  setState(() {});
                                                })
                                          ],
                                        ),
                                        child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            tileColor: Colors.blue.shade100,
                                            title: Column(
                                              children: [
                                                const Text(
                                                  'Nil',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                Text(
                                                  data[index].amount,
                                                  style: data[index].type ==
                                                          'income'
                                                      ? const TextStyle(
                                                          color: Colors.green)
                                                      : const TextStyle(
                                                          color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            subtitle: data[index].description ==
                                                    null
                                                ? const Text(
                                                    'Nil',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.transparent),
                                                  )
                                                : Text(
                                                    data[index].description!,
                                                    textAlign: TextAlign.center,
                                                  ),
                                            leading: CircleAvatar(
                                              radius: 25,
                                              child: Text(
                                                data[index]
                                                    .name
                                                    .substring(0, 2),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                            trailing: Text(data[index].time)),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: data.length)
                            : const Center(
                                child: Text('No Data'),
                              );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildListTile(Data data) => ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      tileColor: Colors.blue.shade100,
      title: Column(
        children: [
          const Text(
            'Nil',
            style: TextStyle(color: Colors.transparent),
          ),
          Text(
            data.amount,
            style: data.type == 'income'
                ? const TextStyle(color: Colors.green)
                : const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      subtitle: data.description == null
          ? const Text(
              'Nil',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.transparent),
            )
          : Text(
              data.description!,
              textAlign: TextAlign.center,
            ),
      leading: CircleAvatar(
        radius: 25,
        child: Text(
          data.name.substring(0, 2),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
      trailing: Text(data.time));
}
