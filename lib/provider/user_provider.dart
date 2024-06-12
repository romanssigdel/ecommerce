import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/services/user_services.dart';
import 'package:ecommerce/services/user_services_impl.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
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

  String? name, email, password, confirmPassword;
  String? errorMessage;
  bool isSuccess = false;
  List<User> userList = [];
  bool isUserExists = false;

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

  StatusUtil _getUserStatus = StatusUtil.none;
  StatusUtil get getUserStatus => _getUserStatus;

  setGetUserStatus(StatusUtil statusUtil) {
    _getUserStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getLoginUserStatus = StatusUtil.none;
  StatusUtil get getLoginUserStatus => _getLoginUserStatus;

  setGetLoginUserStatus(StatusUtil statusUtil) {
    _getLoginUserStatus = statusUtil;
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

  Future<void> getUser() async {
    if (_getUserStatus != StatusUtil.loading) {
      setGetUserStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await userServices.getUserData();
    if (apiResponse.statusUtil == StatusUtil.success) {
      userList = await apiResponse.data;
      setGetUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetUserStatus(StatusUtil.error);
    }
  }

  Future<void> loginCheckUserData() async {
    if (_getLoginUserStatus != StatusUtil.loading) {
      setGetLoginUserStatus(StatusUtil.loading);
    }
    User user = User(email: email, password: password);
    ApiResponse apiResponse = await userServices.checkUserData(user);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isUserExists = apiResponse.data;
      setGetLoginUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetLoginUserStatus(StatusUtil.error);
    }
  }
}
