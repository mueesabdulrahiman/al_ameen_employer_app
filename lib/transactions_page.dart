import 'package:al_ameen/db/mongodb.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  DateTime? datePicker;

  String? formattedFromDate;
  String? formattedDueDate;
  List<String> categoryTypes = ['income', 'expense'];
  String? selectedType;

  @override
  void initState() {
    super.initState();
    MongoDatabase database = MongoDatabase();
    database.refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: MongoDatabase.accountListNotifier,
                builder: (context, value, _) {
                  int income = 0;
                  int expense = 0;

                  for (final result in value) {
                    if (result.type == "income") {
                      income += int.parse(result.amount);
                    } else {
                      expense += int.parse(result.amount);
                    }
                  }

                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Today\'s Profit',
                          style: TextStyle(
                              fontSize: 10.0,
                              letterSpacing: 2.0,
                              color: Colors.grey),
                        ),
                        Text(
                          (income - expense).toString(),
                          style: const TextStyle(
                            fontSize: 50.0,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          income.toString(),
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        const Text(
                                          'Today\'s Income',
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              letterSpacing: 2.0,
                                              color: Colors.grey),
                                        )
                                      ]),
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          expense.toString(),
                                          style:
                                              const TextStyle(fontSize: 20.0),
                                        ),
                                        const Text(
                                          'Today\'s Expence',
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              letterSpacing: 2.0,
                                              color: Colors.grey),
                                        )
                                      ]),
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                  child: FutureBuilder(
                      future: MongoDatabase.getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          return ListView.builder(
                              itemBuilder: (context, index) {
                                return Material(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        tileColor: Colors.grey.shade300,
                                        title: Column(
                                          children: [
                                            const Text(
                                              'Nil',
                                              style: TextStyle(
                                                  color: Colors.transparent),
                                            ),
                                            Text(
                                              data[index].amount,
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
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                          ),
                                        ),
                                        trailing: Text(data[index].time)),
                                  ),
                                );
                              },
                              itemCount: data!.length);
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
