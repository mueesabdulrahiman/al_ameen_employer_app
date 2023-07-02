import 'dart:developer';
import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/view_model/account_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

DateTime? _selectedFromDate;
DateTime? _selectedToDate;
bool _flag = false;

late AccountProvider accountProvider;

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    _flag = false;
  }

  @override
  void dispose() {
    _selectedFromDate = null;
    _selectedToDate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    accountProvider = context.watch<AccountProvider>();

    if (_flag == false &&
        _selectedFromDate == null &&
        _selectedToDate == null) {
      accountProvider.getAllAccountsData();
      accountProvider.getEachEmployeeData();
      _flag = true;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer<AccountProvider>(builder: (context, state, _) {
              int netIncome = 0;
              int netExpense = 0;
              List<Data> documents = state.getAllData;
              for (final document in documents) {
                if (document.type == 'income') {
                  netIncome += int.tryParse(document.amount) ?? 0;
                } else {
                  netExpense += int.tryParse(document.amount) ?? 0;
                }
              }
              return Container(
                height: MediaQuery.of(context).size.width < 500
                    ? MediaQuery.of(context).size.width * 0.20
                    : MediaQuery.of(context).size.width * 0.10,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                // padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                      ),
                      const SizedBox(
                        child: VerticalDivider(
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                      ),
                      const SizedBox(
                        child: VerticalDivider(
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                      ),
                    ]),
              );
            }),

            // date selector
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.width * 0.1
                        : MediaQuery.of(context).size.width * 0.05,
                    width: double.infinity,
                    //color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(children: [
                      Expanded(
                        flex: 2,
                        child: TextButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(_selectedFromDate != null
                              ? accountProvider.aformattedFromDate!
                              : 'From Date'),
                          onPressed: () async {
                            _selectedFromDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now());
                            accountProvider.asetFromDate(_selectedFromDate);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(_selectedToDate != null
                              ? accountProvider.aformattedToDate!
                              : 'To Date'),
                          onPressed: () async {
                            _selectedToDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now());
                            accountProvider.asetToDate(_selectedToDate);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text(
                            'Search',
                          ),
                          onPressed: () async {
                            if (_selectedFromDate != null &&
                                _selectedToDate != null) {
                              accountProvider.getAllAccountsData(
                                  start: accountProvider.afromDate,
                                  end: accountProvider.atoDate);
                              accountProvider.getEachEmployeeData(
                                  fromDate: accountProvider.afromDate,
                                  toDate: accountProvider.atoDate);
                            }
                            _flag = false;
                          },
                        ),
                      ),
                    ]),
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
                    height: MediaQuery.of(context).size.width < 500
                        ? MediaQuery.of(context).size.height * 0.25
                        : MediaQuery.of(context).size.width * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Consumer<AccountProvider>(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Type'),
                              Text('Offline Paid'),
                              Text('Online Paid'),
                              Text('Total'),
                            ],
                          ),
                        ),
                        builder: (context, state, child) {
                          Map<String, List<Data>> data = state.employersData;
                          log('employersdata${state.employersData}');
                          if (data.isNotEmpty) {
                            final keys = data.keys.toList();
                            final values = data.values;
                            return PageView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  int netIncOffline = 0;
                                  int netExpOffline = 0;
                                  int netIncOnline = 0;
                                  int netExpOnline = 0;

                                  final value = values.elementAt(index);
                                  // log('value: $value');
                                  for (var element in value) {
                                    if (element.type == 'income') {
                                      if (element.payment == 'Money') {
                                        netIncOffline +=
                                            int.parse(element.amount);
                                      } else {
                                        netIncOnline +=
                                            int.parse(element.amount);
                                      }
                                    } else if (element.type == 'expense') {
                                      if (element.payment == 'Money') {
                                        netExpOffline +=
                                            int.parse(element.amount);
                                      } else {
                                        netExpOnline +=
                                            int.parse(element.amount);
                                      }
                                    }
                                  }
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          tileColor:
                                              Theme.of(context).primaryColor,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  topRight:
                                                      Radius.circular(20.0))),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  netIncOffline.toString()),
                                            )),
                                            Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(netIncOnline.toString()),
                                            )),
                                            Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  netExpOffline.toString()),
                                            )),
                                            Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(netExpOnline.toString()),
                                            )),
                                            Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                              child: Text(
                                  'Data not available search on other date'),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Graph Based Data ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),

                  //  Linechart data

                  Consumer<AccountProvider>(builder: (context, state, _) {
                    final data = state.getData;

                    return LineChartAccountData(data);
                  }),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartAccountData extends StatelessWidget {
  const LineChartAccountData(this.documents, {super.key});

  final List<Data>? documents;
  List<FlSpot> getChartDataByMonth(List<Data> documents) {
    List<FlSpot> data = documents.isNotEmpty
        ? List.generate(12, (index) => FlSpot(index.toDouble(), 0.0))
        : <FlSpot>[];
    if (documents.isNotEmpty) {
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
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
      height: MediaQuery.of(context).size.width < 500
          ? MediaQuery.of(context).size.height * 0.38
          : MediaQuery.of(context).size.width * 0.5,
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
                spots: getChartDataByMonth(documents ?? []),
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
