import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/model/account_details.dart';

class SearchPage extends StatefulWidget {
 const  SearchPage({super.key});

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

  List<int> fakeData = [160, 100, 90, 200, 500, 240, 300, 210, 70, 80];

  List<AccountDetails> searchData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row(
            //   children: const [
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           hintText: 'From Date',
            //           prefixIcon: Icon(Icons.date_range),
            //           // border: OutlineInputBorder()
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: 'To Date',
            //           prefixIcon: Icon(Icons.date_range),
            //           // border: OutlineInputBorder()
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: DropdownButtonHideUnderline(
            //         child: DropdownButton<String>(
            //           hint: const Text('Type'),
            //           value: selectedType,
            //           items: categoryTypes.map(buildMenuButton).toList(),
            //           onChanged: (value) {
            //             setState(() {
            //               selectedType = value;
            //             });
            //           },
            //           elevation: 1,
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //         child: ElevatedButton(
            //             onPressed: () {}, child: const Text('Apply')))
            //   ],
            // ),

            //or

            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
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
                        lastDate: DateTime.now());

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
                        //textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )),
                const VerticalDivider(
                  color: Colors.black,
                ),

                // elevation: 0,
                //                 onPressed: () async {
                // datePicker = await showDatePicker(
                //     context: context,
                //     initialDate: DateTime.now(),
                //     firstDate:
                //         DateTime.now().subtract(const Duration(days: 365)),
                //     lastDate: DateTime.now());

                // datePicker != null
                //     ? formattedFromDate =
                //         DateFormat.yMMMMd().format(datePicker!)
                //     : null;
                // setState(() {});
                //                 },
                // highlightColor: Colors.transparent,
                // splashColor: Colors.transparent,
                // shape: const RoundedRectangleBorder(),

                // Expanded(
                //     child: MaterialButton(
                //   elevation: 0,
                //   onPressed: () async {
                //     datePicker = await showDatePicker(
                //         context: context,
                //         initialDate: DateTime.now(),
                //         firstDate:
                //             DateTime.now().subtract(const Duration(days: 365)),
                //         lastDate: DateTime.now());

                //     datePicker != null
                //         ? formattedDueDate =
                //             DateFormat.yMMMMd().format(datePicker!)
                //         : null;
                //     setState(() {});
                //   },
                //   color: Colors.grey.shade300,
                //   highlightColor: Colors.transparent,
                //   splashColor: Colors.transparent,
                //   shape: RoundedRectangleBorder(),
                //   child: Text(
                //       formattedDueDate != null ? formattedDueDate! : 'Due'),
                // )),
                Expanded(
                    child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    hint: const Text('Type'),
                    value: selectedType,
                    items: categoryTypes.map(buildMenuButton).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    //elevation: 1,
                    // onPressed: () {
                    //   print('press');
                    // },
                    // color: Colors.grey.shade300,
                    // highlightColor: Colors.transparent,
                    // splashColor: Colors.transparent,
                    // shape: RoundedRectangleBorder(),
                    // child: const Text('Type'),
                  ),
                )),
              ]),
            ),

            ElevatedButton(
                onPressed: () async {
                  if (fromDatePicker != null || toDatePicker != null) {
                    searchData = await MongoDatabase.searchData(
                        start: fromDatePicker!,
                        end: toDatePicker!,
                        type: selectedType!);
                    setState(() {});
                  }
                },
                child: const Text('Apply')),

            //or

            // Container(
            //   height: MediaQuery.of(context).size.height * 0.1,
            //   decoration: BoxDecoration(
            //       color: Colors.grey.shade300,
            //       borderRadius: BorderRadius.circular(10.0)),
            //   child: Row(children: [
            //     Expanded(
            //         child: MaterialButton(
            //       elevation: 0,
            //       onPressed: () async {
            //         datePicker = await showDatePicker(
            //             context: context,
            //             initialDate: DateTime.now(),
            //             firstDate:
            //                 DateTime.now().subtract(const Duration(days: 365)),
            //             lastDate: DateTime.now());

            //         datePicker != null
            //             ? formattedFromDate =
            //                 DateFormat.yMMMMd().format(datePicker!)
            //             : null;
            //         setState(() {});
            //       },
            //       color: Colors.grey.shade300,
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       shape: const RoundedRectangleBorder(),
            //       child: Text(
            //         formattedFromDate != null ? formattedFromDate! : 'From ',
            //       ),
            //     )),
            //     Expanded(
            //         child: MaterialButton(
            //       elevation: 0,
            //       onPressed: () async {
            //         datePicker = await showDatePicker(
            //             context: context,
            //             initialDate: DateTime.now(),
            //             firstDate:
            //                 DateTime.now().subtract(const Duration(days: 365)),
            //             lastDate: DateTime.now());

            //         datePicker != null
            //             ? formattedDueDate =
            //                 DateFormat.yMMMMd().format(datePicker!)
            //             : null;
            //         setState(() {});
            //       },
            //       color: Colors.grey.shade300,
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       shape: RoundedRectangleBorder(),
            //       child: Text(
            //           formattedDueDate != null ? formattedDueDate! : 'Due'),
            //     )),
            //     Expanded(
            //         child: DropdownButtonHideUnderline(
            //       child: DropdownButton<String>(
            //         hint: const Text('Type'),
            //         value: selectedType,
            //         items: categoryTypes.map(buildMenuButton).toList(),
            //         onChanged: (value) {
            //           setState(() {
            //             selectedType = value;
            //           });
            //         },
            //         //elevation: 1,
            //         // onPressed: () {
            //         //   print('press');
            //         // },
            //         // color: Colors.grey.shade300,
            //         // highlightColor: Colors.transparent,
            //         // splashColor: Colors.transparent,
            //         // shape: RoundedRectangleBorder(),
            //         // child: const Text('Type'),
            //       ),
            //     )),
            //     const SizedBox(
            //       width: 0,
            //     ),
            //     Expanded(
            //         child: MaterialButton(
            //       elevation: 0,
            //       onPressed: () {
            //         print('press');
            //       },
            //       color: Colors.grey.shade300,
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       shape: const RoundedRectangleBorder(),
            //       child: const Text('Search'),
            //     )),
            //   ]),
            // ),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 40,
              //MediaQuery.of(context).size.height * 0.03,
              child: Text(
                'Searched Data',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
              ),
            ),
            // const SizedBox(
            //   height: 5.0,
            // ),
            Expanded(
                child: searchData.isNotEmpty
                    ? Material(
                        child: ListView.separated(
                          //shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                tileColor: Colors.grey.shade300,
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
                                    Text(searchData[index].date),
                                    Text(searchData[index].time),
                                  ],
                                ));
                          },
                          itemCount: searchData.length,
                        ),
                      )
                    : const Center(
                        child: Text('Searched data not found '),
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
