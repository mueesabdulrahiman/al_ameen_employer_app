import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/view_model/account_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    final provider = context.watch<AccountProvider>();
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.width < 500
                    ? MediaQuery.of(context).size.height * 0.05
                    : MediaQuery.of(context).size.width * 0.1,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      final fromDatePicker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate: DateTime.now());
                      provider.setFromDate(fromDatePicker);
                    },
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          provider.formattedFromDate != null
                              ? provider.formattedFromDate!
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
                      final toDatePicker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)));

                      provider.setToDate(toDatePicker);
                    },
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          provider.formattedToDate != null
                              ? provider.formattedToDate!
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
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Colors.blue,
                        isDense: true,
                        hint: const Text('Type',
                            style: TextStyle(color: Colors.white)),
                        value: provider.dropDownValue,
                        items: categoryTypes.map(buildMenuButton).toList(),
                        onChanged: (value) {
                          provider.setDropDownValue(value);
                        },
                      ),
                    ),
                    //  )
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width < 500
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.width * 0.07,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (provider.fromDate != null &&
                                provider.toDate != null &&
                                provider.dropDownValue != null) {
                              provider.searchAccountsData(
                                  type: provider.dropDownValue);
                              provider.didSearch = true;
                            }
                          },
                          child: const Text('Apply')),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width < 500
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.width * 0.07,
                      child: ElevatedButton(
                          onPressed: () async {}, child: const Text('Clear')),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              provider.searchedData.isNotEmpty
                  ? const Text(
                      'Searched Data',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18.0),
                    )
                  : const SizedBox(),
              Expanded(
                  child: Consumer<AccountProvider>(builder: (_, state, child) {
                if (state.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.searchedData.isNotEmpty) {
                  return Material(
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
                            tileColor:
                                //Colors.grey.shade300,
                                Colors.blue.shade100,
                            title: Text(
                              state.searchedData[index].amount.toString(),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                                state.searchedData[index].description ?? '',
                                textAlign: TextAlign.center),
                            leading: CircleAvatar(
                              radius: 25,
                              child: Text(
                                state.searchedData[index].name.substring(0, 2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat('dd-MM-yyyy')
                                    .format(state.searchedData[index].date)
                                    .substring(0, 10)),
                                Text(state.searchedData[index].time),
                              ],
                            ));
                      },
                      itemCount: state.searchedData.length,
                    ),
                  );
                } else {
                  if (provider.didSearch == false &&
                      provider.fromDate == null &&
                      provider.toDate == null) {
                    return const Center(
                      child: Text('Search For Data'),
                    );
                  } else {
                    return const Center(
                      child: Text('Searched data not found '),
                    );
                  }
                }
              })),

              // child: Expanded(
              //     child: !state.loading
              //         ? Material(
              //             child: ListView.separated(
              //               padding: const EdgeInsets.only(top: 10.0),
              //               //shrinkWrap: true,
              //               separatorBuilder: (context, index) =>
              //                   const SizedBox(height: 8.0),
              //               itemBuilder: (context, index) {
              //                 // final sortedData = searchData.sort((a, b) => a.,)
              //                 return ListTile(
              //                     contentPadding: const EdgeInsets.symmetric(
              //                         horizontal: 10.0, vertical: 5.0),
              //                     shape: RoundedRectangleBorder(
              //                         borderRadius:
              //                             BorderRadius.circular(10.0)),
              //                     tileColor: Colors.blue.shade100,
              //                     title: Text(
              //                       searchData[index].amount.toString(),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                     subtitle: Text(
              //                         searchData[index].description ?? '',
              //                         textAlign: TextAlign.center),
              //                     leading: CircleAvatar(
              //                       radius: 25,
              //                       child: Text(
              //                         searchData[index].name.substring(0, 2),
              //                         textAlign: TextAlign.center,
              //                         style: const TextStyle(fontSize: 15.0),
              //                       ),
              //                     ),
              //                     trailing: Column(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.center,
              //                       children: [
              //                         Text(DateFormat('dd-MM-yyyy')
              //                             .format(searchData[index].date)
              //                             .substring(0, 10)),
              //                         Text(searchData[index].time),
              //                       ],
              //                     ));
              //               },
              //               itemCount: searchData.length,
              //             ),
              //           )
              //         : Center(
              //             child: Text(flag
              //                 ? 'Searched data not found '
              //                 : 'Search For Data'),
              //           )),
            ],
          ),
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
