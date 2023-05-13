import 'dart:developer';

import 'package:al_ameen/db/mongodb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

final _fromDateController = TextEditingController();
final _toDateController = TextEditingController();
final _node1 = FocusNode();
final _node2 = FocusNode();

DateTime? _selectedFromDate;
DateTime? _selectedToDate;

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    MongoDatabase.refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: MongoDatabase.accountListNotifier,
              builder: (context, documents, _) {
                int income = 0;
                int expense = 0;
                for (final document in documents) {
                  if (document.type == 'income') {
                    income += int.tryParse(document.amount) ?? 0;
                  } else {
                    expense += int.tryParse(document.amount) ?? 0;
                  }
                }
                return Container(
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))),
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,

                  // decoration: BoxDecoration(
                  //     color: Colors.grey.shade300,
                  //     borderRadius: BorderRadius.circular(10.0)),
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
                                    color: Colors.grey),
                              ),
                              Text(
                                income.toString(),
                                style: const TextStyle(
                                  fontSize: 40.0,
                                ),
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
                                    color: Colors.grey),
                              ),
                              Text(
                                (income - expense).toString(),
                                style: const TextStyle(
                                  fontSize: 40.0,
                                ),
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
                                    color: Colors.grey),
                              ),
                              Text(
                                expense.toString(),
                                style: const TextStyle(
                                  fontSize: 40.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(15.0),
              height: 220,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 35, 83),
                  borderRadius: BorderRadius.circular(10.0)),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 100000,
                  borderData: FlBorderData(
                      border: Border.all(color: const Color(0xff37434d))),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color: const Color(0xff37434d), strokeWidth: 1.0);
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                          color: const Color(0xff37434d), strokeWidth: 1.0);
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                        //show: true,
                        spots: const [
                          FlSpot(0, 20000),
                          FlSpot(1, 30000),
                          FlSpot(2, 80000),
                          FlSpot(3, 50000),
                          FlSpot(4, 40000),
                          FlSpot(5, 60000),
                          FlSpot(6, 50000),
                          FlSpot(7, 30000),
                          FlSpot(8, 80000),
                          FlSpot(9, 80000),
                          FlSpot(10, 50000),
                          FlSpot(11, 100000),
                        ],
                        isCurved: true,
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
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 2:
                              return const Text(
                                'MAR',
                                style: TextStyle(color: Colors.white),
                              );

                            case 6:
                              return const Text(
                                'JUL',
                                style: TextStyle(color: Colors.white),
                              );

                            case 9:
                              return const Text(
                                'OCT',
                                style: TextStyle(color: Colors.white),
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
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                ),
              ),
            ),
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
                    label: const Text('From Date'),
                    onPressed: () async {
                      _selectedFromDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now());
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text('To Date'),
                    onPressed: () async {
                      _selectedToDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now());
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ),
              ]),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 10),
            //   width: double.infinity,
            //   height: 50,

            //   decoration:

            //       BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.amber,),
            //       child: Row(children: [],),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('income'),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '1000',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('expense'),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '1000',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Total'),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '1000',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                )
                // Container(
                //   height: 60,
                //   width: 80,
                //   color: Colors.green,
                //   child: const Text(
                //     'income',
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Container(
                //   height: 60,
                //   width: 80,
                //   color: Colors.green,
                //   child: const Text(
                //     'expense',
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Container(
                //   height: 60,
                //   width: 80,
                //   color: Colors.green,
                //   child: const Text(
                //     'total',
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
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
                      'Searched Each Employees Data',
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
            SizedBox(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PageView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            tileColor: Colors.grey.shade500,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            title: const Text('Name'),
                            trailing: const Text('Jaleel'),
                          ),
                          Padding(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Income  '),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('600'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1800'),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Expense'),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('400'),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            tileColor: Colors.grey.shade500,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            title: const Text('Name'),
                            trailing: const Text('Jaleel'),
                          ),
                          Padding(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Income  '),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('600'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1800'),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Expense'),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('200'),
                                  )),
                              Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('400'),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
            // Expanded(
            //   child: Container(
            //     padding:
            //         const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         color: Colors.grey.shade300,
            //         borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(50.0),
            //             topRight: Radius.circular(50.0))),
            //     child: Column(
            //       children: [
                   
            //         // Expanded(
            //         //   child: ListView(
            //         //     shrinkWrap: true,
            //         //     //scrollDirection: Axis.horizontal,
            //         //     children: [
            //         //       Card(
            //         //         shape: RoundedRectangleBorder(
            //         //             borderRadius: BorderRadius.circular(20.0)),
            //         //         child: Column(
            //         //           // mainAxisAlignment: MainAxisAlignment.start,
            //         //           children: [
            //         //             ListTile(
            //         //               tileColor: Colors.grey.shade500,
            //         //               shape: const RoundedRectangleBorder(
            //         //                   borderRadius: BorderRadius.only(
            //         //                       topLeft: Radius.circular(20.0),
            //         //                       topRight: Radius.circular(20.0))),
            //         //               title: const Text('Name'),
            //         //               trailing: const Text('Jaleel'),
            //         //             ),
            //         //             Padding(
            //         //               padding: const EdgeInsets.all(8.0),
            //         //               child: Row(
            //         //                 mainAxisAlignment:
            //         //                     MainAxisAlignment.spaceAround,
            //         //                 children: const [
            //         //                   Text('Type'),
            //         //                   Text('Offline Paid'),
            //         //                   Text('Online Paid'),
            //         //                   Text('Total'),
            //         //                 ],
            //         //               ),
            //         //             ),
            //         //             Row(
            //         //               mainAxisAlignment:
            //         //                   MainAxisAlignment.spaceAround,
            //         //               children: const [
            //         //                 Text('Income  '),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('1200'),
            //         //                     )),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('600'),
            //         //                     )),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('1800'),
            //         //                     )),
            //         //               ],
            //         //             ),
            //         //             const SizedBox(
            //         //               height: 10.0,
            //         //             ),
            //         //             Row(
            //         //               mainAxisAlignment:
            //         //                   MainAxisAlignment.spaceAround,
            //         //               children: const [
            //         //                 Text('Expense'),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('200'),
            //         //                     )),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('200'),
            //         //                     )),
            //         //                 Card(
            //         //                     elevation: 2,
            //         //                     child: Padding(
            //         //                       padding: EdgeInsets.all(8.0),
            //         //                       child: Text('400'),
            //         //                     )),
            //         //               ],
            //         //             ),
            //         //             const SizedBox(
            //         //               height: 10.0,
            //         //             ),
            //         //           ],
            //         //         ),
            //         //       ),

            //         //     ],
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // )
       

// Card(
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 10.0),
                                //   //elevation: 2,
                                //   child: ExpansionTile(
                                //     childrenPadding: const EdgeInsets.all(15.0),
                                //     //backgroundColor: Colors.green.shade300,
                                //     // collapsedBackgroundColor:
                                //     //   Colors.green.shade300,
                                //     title: const Text(
                                //       'Jaleel',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Income'),
                                //           Text('1200')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('700')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('500')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Expense'),
                                //           Text('400')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // Card(
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 10.0),
                                //   elevation: 2,
                                //   child: ExpansionTile(
                                //     childrenPadding: const EdgeInsets.all(15.0),
                                //     // backgroundColor: Colors.grey.shade200,
                                //     title: const Text(
                                //       'Hasan',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Income'),
                                //           Text('1200')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('700')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('500')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Expense'),
                                //           Text('400')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // Card(
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 10.0),
                                //   //elevation: 2,
                                //   child: ExpansionTile(
                                //     childrenPadding: const EdgeInsets.all(15.0),
                                //     //backgroundColor: Colors.green.shade300,
                                //     // collapsedBackgroundColor:
                                //     //   Colors.green.shade300,
                                //     title: const Text(
                                //       'Jaleel',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     children: [
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Income'),
                                //           Text('1200')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('700')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('500')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Expense'),
                                //           Text('400')
                                //         ],
                                //       ),
                                //       const Divider(
                                //         thickness: 1,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Online Payment'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //       const SizedBox(
                                //         height: 10.0,
                                //       ),
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: const [
                                //           Text('Money'),
                                //           Text('200')
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),