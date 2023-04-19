import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

final _fromDateController = TextEditingController();
final _toDateController = TextEditingController();

DateTime? _selectedFromDate;
DateTime? _selectedToDate;

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    color: Colors.grey.shade300,

                    // decoration: BoxDecoration(
                    //     color: Colors.grey.shade300,
                    //     borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Net Profit',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  letterSpacing: 2.0,
                                  color: Colors.grey),
                            ),
                            Text(
                              '2000',
                              style: TextStyle(
                                fontSize: 50.0,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 20.0,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: const [
                                Text(
                                  'Net Income',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      letterSpacing: 2.0,
                                      color: Colors.grey),
                                ),
                                Text(
                                  '2000',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50.0,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            Column(
                              children: const [
                                Text(
                                  'Net Expense',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      letterSpacing: 2.0,
                                      color: Colors.grey),
                                ),
                                Text(
                                  '2000',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Container(
                              height: 10.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Text('All Statistics'),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Name'),
                                            Text('Jaleel')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Income'),
                                            Text('1200')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('700')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('500')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          //color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Expense'),
                                            Text('400')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('200')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('200')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    //height: 150,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      //mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Name'),
                                            Text('Jaleel')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Income'),
                                            Text('1200')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('700')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('500')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          //color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Expense'),
                                            Text('400')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('200')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('200')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    //height: 150,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Name'),
                                            Text('Jaleel')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Income'),
                                            Text('1200')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('700')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('500')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          //color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Expense'),
                                            Text('400')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Online Payment'),
                                            Text('200')
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Money'),
                                            Text('200')
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          // color: Colors.grey,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Profit'),
                                            Text('800')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: 170,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(children: [
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                              controller: _fromDateController,
                              decoration:
                                  const InputDecoration(labelText: 'From'),
                              onTap: () async {
                                _selectedFromDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now());
                                setState(() {
                                  if (_selectedFromDate != null) {
                                    final formattedDate = DateFormat.yMMMMd()
                                        .format(_selectedFromDate!);
                                    log(formattedDate.toString());
                                    _fromDateController.text = formattedDate;
                                  }
                                });
                              })),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _toDateController,
                            decoration: const InputDecoration(labelText: 'To'),
                            onTap: () async {
                              _selectedToDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now());
                              setState(() {
                                if (_selectedToDate != null) {
                                  final formattedDate = DateFormat.yMMMMd()
                                      .format(_selectedToDate!);
                                  log(formattedDate.toString());
                                  _toDateController.text = formattedDate;
                                }
                              });
                            },
                          )),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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