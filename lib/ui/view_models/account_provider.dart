import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:al_ameen/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountProvider extends ChangeNotifier {
  final FirebaseRepositoryImplementation firebase;
  final SharedPreferencesServices sharedPref;

  AccountProvider(this.firebase, this.sharedPref);

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

  bool didSearch = false;
  List<Data> _searchedData = [];
  List<Data> get searchedData => _searchedData;
  final List<String> _categoryTypes = ['Income', 'Expense', 'Both'];
  List<String> get categoryTypes => _categoryTypes;
  String? _dropDownValue;
  String? get dropDownValue => _dropDownValue;

  // add details page variable
  bool _onlinePayment = false;
  CategoryType _categoryType = CategoryType.income;
  bool get onlinePayment => _onlinePayment;
  CategoryType get categoryType => _categoryType;
  String? _selectedChair;
  String? get selectedChair => _selectedChair;
  String? _menuError;
  String? get menuError => _menuError;

  // manage chairs page variable
  List<String> _chairs = [];
  List<String> get chairs => _chairs;
  bool? _hasDeleted;
  bool? get hasDeleted => _hasDeleted;

  // storing inserting model for testing purpose (add details page testing)
  Data? _model;
  Data get model => _model!;

  setModel(Data newModel) async {
    _model = newModel;
  }

  // analytics page variables
  bool _analyticsPageFlag = false;
  bool get analyticsPageFlag => _analyticsPageFlag;
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

  String? _role;
  String? get role => _role;

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
        ? _aformattedFromDate = DateFormat.yMMMd().format(_afromDate!)
        : _aformattedFromDate = null;
    notifyListeners();
  }

  asetToDate(DateTime? atoDate) {
    _atoDate = atoDate;
    _atoDate != null
        ? _aformattedToDate = DateFormat.yMMMd().format(_atoDate!)
        : _aformattedToDate = null;
    notifyListeners();
  }

  changeAnalyticsPageFlow() => _analyticsPageFlag = !_analyticsPageFlag;

  resetAnalyticsPage() {
    _afromDate = null;
    _atoDate = null;
    _aformattedFromDate = null;
    _aformattedToDate = null;
    changeAnalyticsPageFlow();
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

  void setChair(String? selectedEmp) {
    _selectedChair = selectedEmp;
    notifyListeners();
  }

  void setDropdownMenuError(String? error) {
    _menuError = error;
    notifyListeners();
  }

  void setUsername(String name, String role) {
    _username = name;
    _role = role;
  }

  // firebase connection

  void connectFirebase() async {
    await firebase.connect();
    notifyListeners();
  }

  // get data

  Future<void> getAccountsData() async {
    setLoading(true);
    final result = await firebase.getData();
    if (result is Success) {
      setAccountDataList(result.response as List<Data>);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    setLoading(false);
  }

  // get all users

  Future<void> getAllUsersList() async {
    setLoading(true);
    final result = await firebase.getAllUsers();
    if (result is Set<String>) {
      setAllUsersList(result);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    setLoading(false);
  }

  // add data

  Future<void> addAccountsData(Data dataModel) async {
    await firebase.insert(dataModel);
    notifyListeners();
  }

  // delete data

  Future<void> deleteAccountsData(String id) async {
    await firebase.deleteData(id);
    getAccountsData();
  }

  // delete searched data

  Future<void> deleteSearchedData(String id) async {
    await firebase.deleteData(id);
    await searchAccountsData(dropDownValue);
    getAccountsData();
  }

  // search data

  Future<void> searchAccountsData(String? type) async {
    setLoading(true);
    final searchResult =
        await firebase.searchData(start: _fromDate!, end: _toDate!, type: type);
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

  Future<void> getEachEmployeeData(
      {DateTime? fromDate, DateTime? toDate}) async {
    final result =
        await firebase.getEachEmployeeData(fromDate: fromDate, toDate: toDate);
    if (result is Failure) {
      _errorText = result.response.toString();
      notifyListeners();
    } else {
      setEmployersDataList(result as Map<String, List<Data>>);
      notifyListeners();
    }
  }

  // get complete data (including all employees data)

  Future<void> getAllAccountsData({DateTime? start, DateTime? end}) async {
    final res = await firebase.getDashBoardData(fromDate: start, toDate: end);
    if (res is Failure) {
      _errorText = res.response.toString();
      notifyListeners();
    } else {
      setAllAccountsDataList(res is Success ? res.response as List<Data> : res);
      notifyListeners();
    }
  }

  // get profile username
  Future<void> getUsername() async {
    final name = await sharedPref.checkLoginStatus();
    late String formattedRole;

    if (name != null && name.isNotEmpty) {
      final formattedName = name[0].toCapitalized();
      if (name[0].contains('muees')) {
        formattedRole = 'Developer';
      } else if (name[0].contains('jaleel')) {
        formattedRole = 'Admin';
      } else {
        formattedRole = 'Staff Member';
      }
      setUsername(formattedName, formattedRole);
      notifyListeners();
    }
  }

  //  manage chairs crud functions

  setChairsList(List<String> data) {
    data.sort((a, b) {
      int aNumber = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      int bNumber = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return aNumber.compareTo(bNumber);
    });
    _chairs = data;
  }

  setDeleteResult(bool? result) => _hasDeleted = result;

  Future<void> createChair(String chair) async {
    await firebase.insertChair(chair);
    notifyListeners();
  }

  Future<void> deleteChair(String chairname) async {
    final hasDeleted = await firebase.deleteChair(chairname);
    setDeleteResult(hasDeleted);
    // displayChairs();
  }

  Future<void> displayChairs() async {
    final result = await firebase.getChairs();
    if (result is Success) {
      setChairsList(result.response as List<String>);
    } else if (result is Failure) {
      _errorText = '';
      _errorText = result.response.toString();
    }
    notifyListeners();
  }

  Future<void> deleteMultipleData(BuildContext context,
      {required DateTime startDate, required DateTime endDate}) async {
    await firebase.deleteMultipleData(context, start: startDate, end: endDate);
    notifyListeners();
  }
}
