import 'dart:developer';

import 'package:al_ameen/db/mongodb.dart';
import 'package:al_ameen/model/account_details.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key});

  @override
  State<AddDetailsPage> createState() => _HomePageState();
}

enum CategoryType { income, expense }

class _HomePageState extends State<AddDetailsPage> {
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  TextEditingController? _descriptionController;
  final _node1 = FocusNode();
  final _node2 = FocusNode();
  final _node3 = FocusNode();
  CategoryType _selectedCategory = CategoryType.income;
  bool _onlinePayment = false;
  late bool isScrolled;
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dateController.text =
        DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.now());
    //log(DateTime.now().toString());
    //log(DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

//    DateFormat.yMd().add_jm()
  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _descriptionController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isScrolled = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !isScrolled
                  ? const Text(
                      'Add Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 40,
              ),
              TextField(
                focusNode: _node1,
                controller: _dateController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _amountController,
                focusNode: _node2,
                decoration: const InputDecoration(
                  hintText: "Amount",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                focusNode: _node3,
                decoration: const InputDecoration(
                  hintText: 'Description (Optional)',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<CategoryType>(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: CategoryType.income,
                      groupValue: _selectedCategory,
                      onChanged: (value) => setState(() {
                        _selectedCategory = value!;
                      }),
                      title: const Text('Income'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<CategoryType>(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: CategoryType.expense,
                      groupValue: _selectedCategory,
                      onChanged: (value) => setState(() {
                        _selectedCategory = value!;
                      }),
                      title: const Text('Expense'),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _onlinePayment,
                onChanged: (val) => setState(() {
                  _onlinePayment = val!;
                }),
                title: const Text('Online Payment'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    final splittedDate = _dateController.text.split(' ');
                    final formattedDate = splittedDate[0];
                    final time = '${splittedDate[1]} ${splittedDate[2]}';
                    var id = mongo.ObjectId();
                    final faker = Faker();
                    var name = faker.person.name();
                    // setState(() {
                    //   name = faker.person.name();
                    // });

                    final category = _selectedCategory == CategoryType.income
                        ? 'income'
                        : 'expense';
                    final paymentMethod =
                        _onlinePayment ? 'Paid Online' : 'Money';
                    final model = AccountDetails(
                        id: id,
                        name: name,
                        date: formattedDate,
                        time: time,
                        amount: _amountController.text,
                        description: _descriptionController?.text ?? '',
                        type: category,
                        payment: paymentMethod);
                    final res = await MongoDatabase.insert(model);
                    log(res.toString());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
