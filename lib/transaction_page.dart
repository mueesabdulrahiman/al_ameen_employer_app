import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/view_model/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // final accountProvider =
    //     Provider.of<AccountProvider>(context, listen: false);
    // accountProvider.getAccountsData();
    //context.watch<AccountProvider>();
    //log('getData:${accountProvider.getData}');
    //});

    // Provider.of<AccountProvider>(context, listen: false);

    //WidgetsBinding.instance.addPostFrameCallback((_) {
    //FirebaseDB.getData2();
    //Provider.of<AccountProvider>(context, listen: false).getAccountsData();
    // AccountProvider accountProvider = Provider.of<AccountProvider>(context, listen: false);
    // log('getData:${accountProvider.getData}');
    //  });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
          child: Column(
            children: [
              Consumer<AccountProvider>(
                builder: (context, state, child) {
                  int income = 0;
                  int expense = 0;
                  var value = state.getData;
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
                    height: MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.height * 0.25
                        : MediaQuery.of(context).size.width * 0.3,
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            //color: Colors.black,
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
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Row(
                                    children: [
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
                                  const Row(
                                    children: [
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
              const SizedBox(
                height: 10,
              ),
              Expanded(child: Consumer<AccountProvider>(
                builder: (context, res, _) {
                  final value = res.getData;
                  List<Data> data = [];
                  if (value.isNotEmpty) {
                    DateTime currentDate = DateTime.now();
                    data = value.where((element) {
                      final res = element.date.day == currentDate.day &&
                          element.date.month == currentDate.month;
                      return res == true;
                    }).toList();
                  }
                  if (res.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.isNotEmpty) {
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          return Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                        icon: Icons.delete,
                                        onPressed: (context) {
                                          if (data[index].id != null) {
                                            Provider.of<AccountProvider>(
                                                    context,
                                                    listen: false)
                                                .deleteAccountsData(
                                                    data[index].id!);
                                          }
                                        })
                                  ],
                                ),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    tileColor: Colors.blue.shade100,
                                    //Colors.grey.shade300,
                                    title: Column(
                                      children: [
                                        const Text(
                                          'Nil',
                                          style: TextStyle(
                                              color: Colors.transparent),
                                        ),
                                        Text(
                                          data[index].payment == 'Money'
                                              ? data[index].amount
                                              : "${data[index].amount} (UPI)",
                                          style: data[index].type == 'income'
                                              ? const TextStyle(
                                                  color: Colors.green)
                                              : const TextStyle(
                                                  color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    subtitle: data[index].description == null
                                        ? const Text(
                                            'Nil',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.transparent),
                                          )
                                        : Text(
                                            data[index].description!,
                                            textAlign: TextAlign.center,
                                          ),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      child: Text(
                                        data[index].name.substring(0, 2),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                    trailing: Text(data[index].time)),
                              ),
                            ),
                          );
                        },
                        itemCount: data.length);
                  } else {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }
                },
              )),
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
