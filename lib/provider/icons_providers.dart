import 'package:flutter/material.dart';

class IconsProvider extends ChangeNotifier{
  bool _showPassword = false;
  bool get showPassword => _showPassword;

  bool _showConfirmPassword = false;
  bool get showConfirmPassword => _showConfirmPassword;

  setShowPassword() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  setShowConfirmPassword() {
    _showConfirmPassword = !_showConfirmPassword;
    notifyListeners();
  }
}