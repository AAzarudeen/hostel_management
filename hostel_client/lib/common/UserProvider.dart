import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late User _currentUser;

  User get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
