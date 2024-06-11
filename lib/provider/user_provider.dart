import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/services/user_services.dart';
import 'package:ecommerce/services/user_services_impl.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? name, email, password, confirmPassword;
  String? errorMessage;
  bool isSuccess = false;

  UserServices userServices = UserServicesImplementation();

  setName(value) {
    name = value;
  }

  setEmail(value) {
    email = value;
  }

  setPassword(value) {
    password = value;
  }

  setConfirmPassword(value) {
    confirmPassword = value;
  }

  StatusUtil _saveUserStatus = StatusUtil.none;
  StatusUtil get saveUserStatus => _saveUserStatus;

  setSaveUserStatus(StatusUtil statusUtil) {
    _saveUserStatus = statusUtil;
    notifyListeners();
  }

  Future<void> saveStudentData() async {
    if (_saveUserStatus != StatusUtil.loading) {
      setSaveUserStatus(StatusUtil.loading);
    }
    
    User user = User(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword);

    ApiResponse apiResponse = await userServices.saveUserData(user);

    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setSaveUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setSaveUserStatus(StatusUtil.error);
    }
  }
}
