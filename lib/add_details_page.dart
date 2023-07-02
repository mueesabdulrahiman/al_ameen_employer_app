import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/view_model/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:provider/provider.dart';

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key});

  @override
  State<AddDetailsPage> createState() => _HomePageState();
}

enum CategoryType { income, expense }

final _scaffoldKey = GlobalKey<ScaffoldState>();
final _formKey = GlobalKey<FormState>();

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
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  DateTime? formattedDate;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dateController.text =
        DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.now());
    //formattedDate = ;
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
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  focusNode: _node1,
                  controller: _dateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'date should not be empty';
                    } else {
                      return null;
                    }
                  },
                  onTap: () async {
                    pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year, 1, 1),
                        lastDate: DateTime(DateTime.now().year, 12, 31));
                    pickedTime = const TimeOfDay(hour: 12, minute: 0);
                    // await showTimePicker(
                    //     context: context,
                    //     initialTime: const TimeOfDay(hour: 12, minute: 0));
                    setState(() {
                      if (pickedDate != null) {
                        formattedDate = DateTime.utc(
                            pickedDate!.year,
                            pickedDate!.month,
                            pickedDate!.day,
                            pickedTime!.hour,
                            pickedTime!.minute);
                        _dateController.text = DateFormat('dd-MM-yyyy HH:mm a')
                            .format(formattedDate!);
                      } else {
                        formattedDate = DateTime.now().toUtc();
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _amountController,
                  focusNode: _node2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'amount should not be empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Amount",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _descriptionController,
                  focusNode: _node3,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'description should not be empty';
                  //   } else {
                  //     return null;
                  //   }
                  // },
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
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        final splittedDate = _dateController.text.split(' ');
                        final time = '${splittedDate[1]} ${splittedDate[2]}';
                        // var id = mongo.ObjectId();
                        formattedDate ??= DateTime.utc(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day);

                        final category =
                            _selectedCategory == CategoryType.income
                                ? 'income'
                                : 'expense';
                        final paymentMethod =
                            _onlinePayment ? 'Paid Online' : 'Money';
                        // final model = AccountDetails(
                        //     id: id,
                        //     name: MongoDatabase.name ?? 'muees',
                        //     date: formattedDate ?? DateTime.now().toUtc(),
                        //     //     DateTime.utc(DateTime.now().year,
                        //     // DateTime.now().month, DateTime.now().day),
                        //     time: time,
                        //     amount: _amountController.text,
                        //     description: _descriptionController?.text ?? '',
                        //     type: category,
                        //     payment: paymentMethod);

                        final model2 = Data(
                          name: FirebaseDB.currentUser ?? "Muees",
                          date: formattedDate ?? DateTime.now(),
                          time: time,
                          amount: _amountController.text,
                          description: _descriptionController?.text,
                          type: category,
                          payment: paymentMethod,
                        );
                        // await FirebaseDB.insert(model2);
                        // await FirebaseDB.getData2();
                        Provider.of<AccountProvider>(context, listen: false)
                            .addAccountsData(model2);
                        Provider.of<AccountProvider>(context, listen: false)
                            .getAccountsData();

                        // await MongoDatabase.insert(model);
                        // await MongoDatabase.getData();

                        Navigator.pop(_scaffoldKey.currentContext!);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
