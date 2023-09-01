import 'dart:developer';

import 'package:al_ameen/data/models/api_status.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/data/repository/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginProvider extends ChangeNotifier {
  FirebaseRepositoryImplementation firebaseRepo =
      GetIt.instance<FirebaseRepositoryImplementation>();

  UserCredential? _loggedUser;
  UserCredential? get loggedUser => _loggedUser;
  String? _currentUser;
  String? get currentUser => _currentUser;
  String? _errorText;
  String? get errorText => _errorText;

  bool _changeIcon = true;
  bool get changeIcon => _changeIcon;

  bool passwordIconChange() {
    _changeIcon = !_changeIcon;
    notifyListeners();
    return changeIcon;
  }

  Future<void> userLogin(BuildContext context, Login loginModel) async {
    final result = await firebaseRepo.signInUser(loginModel, context);
    if (result is UserCredential) {
      _loggedUser = result;
      _currentUser = result.user!.email!.substring(0, 1) +
          result.user!.email!.substring(1);
      log("currentuser:$_currentUser");
    } else if (result is Failure) {
      _errorText = result.response as String;
    }
    notifyListeners();
  }

  void resetLog() {
    _loggedUser = null;
  }
}
