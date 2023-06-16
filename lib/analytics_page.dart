import 'dart:developer';
import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:al_ameen/model/data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

DateTime? _selectedFromDate;
DateTime? _selectedToDate;
bool flag = false;

List<AccountDetails> searchedData = [];

late FirebaseDB firebase;

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    FirebaseDB.getData();
    firebase = FirebaseDB();
    firebase.getDashBoardData();
   firebase.getEachEmployeeData();
   // retrieve();
  }

  @override
  void dispose() {
    _selectedFromDate = null;
    _selectedToDate = null;

    super.dispose();
  }

  retrieve() async {
    await firebase.getEachEmployeeData();
  }

  Map<String, List<AccountDetails>>? searchedEmployeesData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: Colors.grey.shade300,
      //   foregroundColor: Colors.black,
      //   title: const Text(
      //     'Analytics Page',
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard
            // const SizedBox(
            //   height: 5.0,
            // ),
            ValueListenableBuilder(
              valueListenable: FirebaseDB.searchedAccountListNotifier,
              builder: (context, documents, _) {
                int netIncome = 0;
                int netExpense = 0;
                for (final document in documents) {
                  if (document.type == 'income') {
                    netIncome += int.tryParse(document.amount) ?? 0;
                  } else {
                    netExpense += int.tryParse(document.amount) ?? 0;
                  }
                }
                return Container(
                  height: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Net Income',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    letterSpacing: 2.0,
                                    color: Colors.black),
                              ),
                              Text(
                                netIncome.toString(),
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          // height: 50,
                          child: VerticalDivider(
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Net Balance',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    letterSpacing: 2.0,
                                    color: Colors.black),
                              ),
                              Text(
                                (netIncome - netExpense).toString(),
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          // height: 50,
                          child: VerticalDivider(
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Net Expense',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    letterSpacing: 2.0,
                                    color: Colors.black),
                              ),
                              Text(
                                netExpense.toString(),
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ]),
                );
              },
            ),
            // date selector

            Container(
              margin: const EdgeInsets.all(10.0),
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Row(children: [
                Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: _selectedFromDate != null
                        ? Text(DateFormat.MMMMd().format(_selectedFromDate!))
                        : const Text('From Date'),
                    onPressed: () async {
                      _selectedFromDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now());
                      setState(() {});

                      log(_selectedFromDate.toString());
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: _selectedToDate != null
                        ? Text(DateFormat.MMMMd().format(_selectedToDate!))
                        : const Text('To Date'),
                    onPressed: () async {
                      _selectedToDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now());
                      setState(() {});
                      log(_selectedToDate.toString());
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: const Text(
                      'Search',
                      //color: Colors.blue,
                    ),
                    onPressed: () async {
                      if (_selectedFromDate != null &&
                          _selectedToDate != null) {
                        await firebase.getEachEmployeeData(
                            fromDate: _selectedFromDate,
                            toDate: _selectedToDate);
                        await firebase.getDashBoardData(
                            fromDate: _selectedFromDate,
                            toDate: _selectedToDate);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ]),
            ),

            // show search based dashboard

            // Visibility(
            //   visible: (searchedEmployeesData != null &&
            //           _selectedFromDate != null &&
            //           _selectedToDate != null)
            //       ? true
            //       : false,
            //   child: ValueListenableBuilder(
            //     valueListenable: MongoDatabase.accountListNotifier,
            //     builder: (context, value, _) {
            //       int searchedIncome = 0;
            //       int searchedExpense = 0;
            //       final datas = value
            //           .where((element) =>
            //               (element.date.isAfter(_selectedFromDate!) &&
            //                       element.date.isBefore(_selectedToDate!) ||
            //                   element.date.day == _selectedFromDate!.day ||
            //                   element.date.day == _selectedToDate!.day))
            //           .toList();
            //       //  log("datas: $datas");
            //       for (final d in datas) {
            //         if (d.type == 'income') {
            //           searchedIncome += int.tryParse(d.amount) ?? 0;
            //         } else {
            //           searchedExpense += int.tryParse(d.amount) ?? 0;
            //         }
            //       }
            //       return Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
            //           children: [
            //             Column(
            //               children: [
            //                 const Text('Income'),
            //                 Card(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10)),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: Text(
            //                       searchedIncome.toString(),
            //                       style: const TextStyle(fontSize: 20),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Column(
            //               children: [
            //                 const Text('Expense'),
            //                 Card(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10)),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: Text(
            //                       searchedExpense.toString(),
            //                       style: const TextStyle(fontSize: 20),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Column(
            //               children: [
            //                 const Text('Total'),
            //                 Card(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10)),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(10.0),
            //                     child: Text(
            //                       (searchedIncome - searchedExpense).toString(),
            //                       style: const TextStyle(fontSize: 20),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ]);
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Data of Each Employee ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Swipe >>',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // each employee data card

            SizedBox(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ValueListenableBuilder(
                  valueListenable:
                      FirebaseDB.searchedEmployeeAccountListNotifier,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Type'),
                        Text('Offline Paid'),
                        Text('Online Paid'),
                        Text('Total'),
                      ],
                    ),
                  ),
                  builder: (context, result, child) {
                    if (result.isNotEmpty) {
                      final keys = result.keys.toList();
                      final values = result.values;
                      return PageView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            int netIncOffline = 0;
                            int netExpOffline = 0;
                            int netIncOnline = 0;
                            int netExpOnline = 0;

                            final value = values.elementAt(index);
                            for (var element in value) {
                              if (element.type == 'income') {
                                if (element.payment == 'Money') {
                                  netIncOffline += int.parse(element.amount);
                                } else {
                                  netIncOnline += int.parse(element.amount);
                                }
                              } else if (element.type == 'expense') {
                                if (element.payment == 'Money') {
                                  netExpOffline += int.parse(element.amount);
                                } else {
                                  netExpOnline += int.parse(element.amount);
                                }
                              }
                            }
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Column(
                                children: [
                                  ListTile(
                                    tileColor: Theme.of(context).primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0))),
                                    title: const Text('Name'),
                                    trailing: Text(
                                      keys.elementAt(index),
                                      style: TextStyle(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child!,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('Income'),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(netIncOffline.toString()),
                                      )),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(netIncOnline.toString()),
                                      )),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            (netIncOnline + netIncOffline)
                                                .toString()),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('Expense'),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(netExpOffline.toString()),
                                      )),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(netExpOnline.toString()),
                                      )),
                                      Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            (netExpOffline + netExpOnline)
                                                .toString()),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('Data not available search on other date'),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 0.0,
            ),

            //  Linechart data

            ValueListenableBuilder(
                valueListenable: FirebaseDB.accountListNotifier,
                builder: (context, value, _) {
                  return LineChartAccountData(value);
                }),
            //const Spacer(),
            const SizedBox(
              height: 50.0,
            ),

            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

class LineChartAccountData extends StatelessWidget {
  const LineChartAccountData(this.documents, {super.key});

  final List<Data> documents;
  List<FlSpot> getChartDataByMonth(List<Data> documents) {
    List<FlSpot> data =
        List.generate(12, (index) => FlSpot(index.toDouble(), 0.0));
    for (var document in documents) {
      if (document.date.month >= 1 && document.date.month <= 12) {
        final index = document.date.month - 1;
        final existingSpot = data[index];
        final spotAmount = double.tryParse(document.amount) ?? 0.0;
        final updatedSpot = FlSpot(
            existingSpot.x,
            existingSpot.y +
                (document.type == 'income' ? spotAmount : -spotAmount));
        data[index] = updatedSpot;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 35, 83),
          borderRadius: BorderRadius.circular(10.0)),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: 100000,
          borderData:
              FlBorderData(border: Border.all(color: const Color(0xff37434d))),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: const Color(0xff37434d), strokeWidth: 1.0);
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(color: const Color(0xff37434d), strokeWidth: 1.0);
            },
          ),
          lineBarsData: [
            LineChartBarData(
                //show: true,
                spots: getChartDataByMonth(documents),
                isCurved: false,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: false,
                ),
                color: const Color.fromARGB(255, 76, 164, 185),
                belowBarData: BarAreaData(
                    show: true,
                    color: const Color.fromARGB(255, 76, 164, 185)
                        .withOpacity(0.2)))
          ],
          titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 2:
                      return const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          'MAR',
                          style: TextStyle(color: Colors.white),
                        ),
                      );

                    case 6:
                      return const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          'JUL',
                          style: TextStyle(color: Colors.white),
                        ),
                      );

                    case 10:
                      return const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          'NOV',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                  }
                  return const SizedBox();
                },
                reservedSize: 20.0,
              )),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 20000:
                          return const Text(
                            '20k',
                            style: TextStyle(color: Colors.white),
                          );
                        case 40000:
                          return const Text(
                            '40k',
                            style: TextStyle(color: Colors.white),
                          );
                        case 60000:
                          return const Text(
                            '60k',
                            style: TextStyle(color: Colors.white),
                          );
                        case 80000:
                          return const Text(
                            '80k',
                            style: TextStyle(color: Colors.white),
                          );
                        case 100000:
                          return const Text(
                            '100k',
                            style: TextStyle(color: Colors.white),
                          );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 35),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false))),
        ),
      ),
    );
  }
}
