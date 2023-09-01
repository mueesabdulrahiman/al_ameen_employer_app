import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/utils/locator.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountProvider extends ChangeNotifier {
  AccountProvider() {
    getAccountsData();
  }

  // loading variable
  bool _loading = false;
  bool get loading => _loading;

  // fetch data variable
  List<Data> _getData = [];
  List<Data> get getData => _getData;

  // search page variables
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
  List<Data> _searchedData = [];
  List<Data> get searchedData => _searchedData;

  // add details page variable
  bool _onlinePayment = false;
  CategoryType _categoryType = CategoryType.income;
  bool get onlinePayment => _onlinePayment;
  CategoryType get categoryType => _categoryType;

  // analytics page variables
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

  //profile page name
  String? _username;
  String? get username => _username;

  // error handle variable
  late String _errorText;
  String get errorText => _errorText;

  // fetch all users variable
  Set<String> _allUsersList = {};
  Set<String> get allUsersList => _allUsersList;

  // functions to assign data from  different functions to  respective variables
  setLoading(bool isLoading) {
    _loading = isLoading;
    notifyListeners();
  }

  setAccountDataList(List<Data> data) {
    _getData = data;
  }

  setAllUsersList(Set<String> users) {
    _allUsersList = users;
  }

  setSearchedDataList(List<Data> searchData) {
    _searchedData = searchData;
  }

  // search page data picker

  setFromDate(DateTime? fromDate) {
    _fromDate = fromDate;
    _formattedFromDate =
        _fromDate != null ? DateFormat.MMMMd().format(_fromDate!) : null;
    notifyListeners();
  }

  setToDate(DateTime? toDate) {
    _toDate = toDate;
    _formattedToDate =
        _toDate != null ? DateFormat.MMMMd().format(_toDate!) : null;
    notifyListeners();
  }

  setDropDownValue(String? value) {
    _dropDownValue = value;

    notifyListeners();
  }

//analytics page date picker

  asetFromDate(DateTime? afromDate) {
    _afromDate = afromDate;
    _afromDate != null
        ? _aformattedFromDate = DateFormat.MMMMd().format(_afromDate!)
        : _aformattedFromDate = null;
    notifyListeners();
  }

  asetToDate(DateTime? atoDate) {
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

  void setHasPaidOnline(bool isEnabled) {
    _onlinePayment = isEnabled;
    notifyListeners();
  }

  void setCategoryType(CategoryType type) {
    _categoryType = type;
    notifyListeners();
  }

  void setUsername(String name) {
    _username = '';
    _username = name;
  }

  // firebase connection

  void connectFirebase() async {
    await firebaseRepo.connect();
    notifyListeners();
  }

  // get data

  void getAccountsData() async {
    setLoading(true);
    final result = await firebaseRepo.getData();
    if (result is Success) {
      setAccountDataList(result.response as List<Data>);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    setLoading(false);
  }

  // get all users

  void getAllUsersList() async {
    setLoading(true);
    final result = await firebaseRepo.getAllUsers();
    if (result is Set<String>) {
      setAllUsersList(result);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    setLoading(false);
  }

  // add data

  void addAccountsData(Data dataModel) async {
    await firebaseRepo.insert(dataModel);
    notifyListeners();
  }

  // delete data

  void deleteAccountsData(String id) async {
    await firebaseRepo.deleteData(id);
    getAccountsData();
  }

  // delete searched data

  void deleteSearchedData(String id) async {
    await firebaseRepo.deleteData(id);
    searchAccountsData(type: dropDownValue);
    getAccountsData();
  }

  // search data

  void searchAccountsData({String? type}) async {
    setLoading(true);
    final searchResult = await firebaseRepo.searchData(
        start: _fromDate!, end: _toDate!, type: type);
    setSearchedDataList(searchResult);
    setLoading(false);
  }

  // reset search data

  void resetSearchData() {
    _searchedData.clear();
    _fromDate = null;
    _formattedFromDate = null;
    _formattedToDate = null;
    _toDate = null;
    _dropDownValue = null;
    didSearch = false;
    notifyListeners();
  }

  // get each employee statistics

  void getEachEmployeeData({DateTime? fromDate, DateTime? toDate}) async {
    final res = await firebaseRepo.getEachEmployeeData(
        fromDate: fromDate, toDate: toDate);
    if (res is Failure) {
      _errorText = res.response.toString();
      notifyListeners();
    } else {
      setEmployersDataList(res as Map<String, List<Data>>);
      notifyListeners();
    }
  }

  // get complete data (including all employees data)

  void getAllAccountsData({DateTime? start, DateTime? end}) async {
    final res =
        await firebaseRepo.getDashBoardData(fromDate: start, toDate: end);
    if (res is Failure) {
      _errorText = res.response.toString();
      notifyListeners();
    } else {
      setAllAccountsDataList(
          res is Success ? res.response as List<Data> : res as List<Data>);
      notifyListeners();
    }
  }

  // get profile username
  Future<void> getUsername() async {
    final name = await SharedPreferencesServices.checkLoginStatus();
    if (name != null && name.isNotEmpty) {
      final formattedName =
          name[0].substring(0, 1).toUpperCase() + name[0].substring(1);
      setUsername(formattedName);
      notifyListeners();
    }
  }
}
