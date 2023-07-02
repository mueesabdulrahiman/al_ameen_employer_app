import 'package:al_ameen/db/api_status.dart';
import 'package:al_ameen/db/firebasedb.dart';
import 'package:al_ameen/model/data.dart';
import 'package:al_ameen/model/login_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  UserCredential? _loggedUser;
  UserCredential? get loggedUser => _loggedUser;
  List<Data> _getData = [];
  List<Data> get getData => _getData;

  List<Data> _searchedData = [];
  List<Data> get searchedData => _searchedData;

  //search page variable
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  String? _formattedFromDate;
  String? _formattedToDate;
  String? get formattedFromDate => _formattedFromDate;
  String? get formattedToDate => _formattedToDate;
  String? _dropDownValue;
  String? get dropDownValue => _dropDownValue;
  bool didSearch = false;
  bool flag = false;

// analytics page variable

  DateTime? _afromDate;
  DateTime? _atoDate;
  DateTime? get afromDate => _afromDate;
  DateTime? get atoDate => _atoDate;
  String? _aformattedFromDate;
  String? _aformattedToDate;
  String? get aformattedFromDate => _aformattedFromDate;
  String? get aformattedToDate => _aformattedToDate;

  Map<String, List<Data>> _employersData = {};
  Map<String, List<Data>> get employersData => _employersData;
  List<Data> _getAllData = [];
  List<Data> get getAllData => _getAllData;
  late String _errorText;
  String get errorText => _errorText;

  FirebaseDB firebaseDB = FirebaseDB();

  AccountProvider() {
    getAccountsData();
  }

  setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }

  setAccountDataList(List<Data> data) {
    _getData = data;
  }

  setSearchedDataList(List<Data> searchData) {
    _searchedData = searchData;
  }

// search page data picker
  setFromDate(DateTime? fromDate) {
    //_fromDate = null;
    _fromDate = fromDate;
    _fromDate != null
        ? _formattedFromDate = DateFormat.MMMMd().format(_fromDate!)
        : _formattedFromDate = null;
    notifyListeners();
  }

  setToDate(DateTime? toDate) {
    _toDate = null;
    _toDate = toDate;
    _toDate != null
        ? _formattedToDate = DateFormat.MMMMd().format(_toDate!)
        : _formattedToDate = null;
    notifyListeners();
  }

  setDropDownValue(String? value) {
    _dropDownValue = value;
    notifyListeners();
  }

//analytics page date picker

  asetFromDate(DateTime? afromDate) {
    //_fromDate = null;
    _afromDate = afromDate;
    _afromDate != null
        ? _aformattedFromDate = DateFormat.MMMMd().format(_afromDate!)
        : _aformattedFromDate = null;
    notifyListeners();
  }

  asetToDate(DateTime? atoDate) {
    //_atoDate = null;
    _atoDate = atoDate;
    _atoDate != null
        ? _aformattedToDate = DateFormat.MMMMd().format(_atoDate!)
        : _aformattedToDate = null;
    notifyListeners();
  }

  setAllAccountsDataList(List<Data> allData) {
    _getAllData = allData;
  }

  setEmployersDataList(Map<String, List<Data>> employersData) {
    _employersData = employersData;
  }

  void connectFirebase() async {
    await FirebaseDB.connect();
    notifyListeners();
  }

  void userLogin(Login loginModel, BuildContext context) async {
    final user = await FirebaseDB.signInUser(loginModel, context);
    _loggedUser = user;
    notifyListeners();
  }

  void getAccountsData() async {
    setLoading(true);
    final response = await FirebaseDB.getData2();
    if (response is Success) {
      setAccountDataList(response.response as List<Data>);
    }
    if (response is Failure) {
      _errorText = response.response.toString();
    }
    setLoading(false);
  }

  void addAccountsData(Data dataModel) async {
    await FirebaseDB.insert(dataModel);
    notifyListeners();
  }

  void deleteAccountsData(String id) async {
    await FirebaseDB.deleteData(id);
    getAccountsData();
    notifyListeners();
  }

  void searchAccountsData({String? type}) async {
    setLoading(true);
    final searchResult = await FirebaseDB.searchData(
        start: _fromDate!, end: _toDate!, type: type);
    setSearchedDataList(searchResult);
    setLoading(false);
  }

  void getEachEmployeeData({DateTime? fromDate, DateTime? toDate}) async {
    final res = await firebaseDB.getEachEmployeeData(
        fromDate: fromDate, toDate: toDate);
    if (res is Failure) {
      _errorText = res.response.toString();
      notifyListeners();
    } else {
      setEmployersDataList(res as Map<String, List<Data>>);
      notifyListeners();
      
    }
  }

  void getAllAccountsData({DateTime? start, DateTime? end}) async {
    //getAccountsData();
    //setLoading(true);
    final res = await firebaseDB.getDashBoardData(fromDate: start, toDate: end);
    if (res is Failure) {
      _errorText = res.response.toString();
      notifyListeners();
      // setLoading(false);
    } else {
      setAllAccountsDataList(
          res is Success ? res.response as List<Data> : res as List<Data>);
      flag = true;
      notifyListeners();
      //setLoading(false);
    }
  }
}
