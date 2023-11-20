import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseRepositoryImplementation firebase;
  LoginProvider(this.firebase);
  String? _loggedUser;
  String? get loggedUser => _loggedUser;
  String? _currentUser;
  String? get currentUser => _currentUser;
  String? _errorText;
  String? get errorText => _errorText;

  bool _isFailed = false;
  bool get isFailed => _isFailed;

  bool _changeIcon = true;
  bool get changeIcon => _changeIcon;

  setFailure(bool fail) {
    _isFailed = fail;
  }

  void setCurrentUser(String email) {
    _currentUser = email;
  }

  bool passwordIconChange() {
    _changeIcon = !_changeIcon;
    notifyListeners();
    return changeIcon;
  }

  Future<void> userLogin(BuildContext context, Login loginModel) async {
    final result = await firebase.signInUser(loginModel, context);
    if (result is Success) {
      final user = result.response as String;
      setCurrentUser(user.substring(0, 1) + user.substring(1));
    } else if (result is Failure) {
      _errorText = result.response as String;
    }
    notifyListeners();
  }
}
