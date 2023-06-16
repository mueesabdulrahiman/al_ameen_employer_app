import 'dart:math';

import 'package:al_ameen/analytics_page.dart';
import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/model/account_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime? fromDatePicker;
  DateTime? toDatePicker;

  String? formattedFromDate;
  String? formattedDueDate;
  List<String> categoryTypes = ['Income', 'Expense', 'Both'];
  String? selectedType;
  bool flag = false;

  List<Data> searchData = [];

  @override
  void initState() {
    super.initState();
   // getData();
  }

  getData() async {
    searchData = await FirebaseDB.getData2();

    setState(() {});
  }

  @override
  void dispose() {
    //searchData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    fromDatePicker = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now());

                    fromDatePicker != null
                        ? formattedFromDate =
                            DateFormat.MMMMd().format(fromDatePicker!)
                        : null;
                    setState(() {});
                  },
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        formattedFromDate != null
                            ? formattedFromDate!
                            : 'From Date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )),
                const VerticalDivider(
                  color: Colors.black,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    toDatePicker = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate:DateTime.now().add(const Duration(days: 30) ));

                    toDatePicker != null
                        ? formattedDueDate =
                            DateFormat.MMMMd().format(toDatePicker!)
                        : null;
                    setState(() {});
                  },
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        formattedDueDate != null
                            ? formattedDueDate!
                            : 'To Date ',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )),
                const VerticalDivider(
                  color: Colors.black,
                ),
                Expanded(
                    child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    iconEnabledColor: Colors.white,
                    isDense: true,
                    hint: const Text('Type',
                        style: TextStyle(color: Colors.white)),
                    value: selectedType,
                    items: categoryTypes.map(buildMenuButton).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                )),
              ]),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (fromDatePicker != null && toDatePicker != null && selectedType != null) {
                    searchData = await FirebaseDB.searchData(
                        start: fromDatePicker!,
                        end: toDatePicker!,
                        type: selectedType!);
                    flag = true;
                    setState(() {});
                  }
                },
                child: const Text('Apply')),
            const SizedBox(
              height: 10.0,
            ),
            searchData.isNotEmpty
                ? const Text(
                    'Searched Data',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                  )
                : const SizedBox(),
            Expanded(
                child: searchData.isNotEmpty
                    ? Material(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 10.0),
                          //shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            // final sortedData = searchData.sort((a, b) => a.,)
                            return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                tileColor: Colors.blue.shade100,
                                title: Text(
                                  searchData[index].amount.toString(),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Text(
                                    searchData[index].description ?? '',
                                    textAlign: TextAlign.center),
                                leading: CircleAvatar(
                                  radius: 25,
                                  child: Text(
                                    searchData[index].name.substring(0, 2),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateFormat('dd-MM-yyyy')
                                        .format(searchData[index].date)
                                        .substring(0, 10)),
                                    Text(searchData[index].time),
                                  ],
                                ));
                          },
                          itemCount: searchData.length,
                        ),
                      )
                    : Center(
                        child: Text(flag
                            ? 'Searched data not found '
                            : 'Search For Data'),
                      )),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuButton(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item),
    );
  }
}
