import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/services/user_services.dart';
import 'package:ecommerce/services/user_services_impl.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? id;
  String? name, email, password, confirmPassword;
  TextEditingController? roleTextField;
  String? errorMessage;
  bool isSuccess = false;
  List<User> userList = [];
  bool isUserExists = false;
  String? userId;
  bool? isSuccessfullyUserDataDeleted;

  bool isCheckRememberMe = false;

  String? userRole;

  setSaveCheckRememberMe(value) {
    isCheckRememberMe = value!;
    notifyListeners();
  }

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();

  UserServices userServices = UserServicesImplementation();

  setRole(value) {
    roleTextField = TextEditingController(text: value);
  }

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

  StatusUtil _getDeleteUserStatus = StatusUtil.none;
  StatusUtil get getDeleteUserStatus => _getDeleteUserStatus;

  setGetDeleteUserStatus(StatusUtil statusUtil) {
    _getDeleteUserStatus = statusUtil;
    notifyListeners();
  }

  Future<void> saveStudentData() async {
    if (_saveUserStatus != StatusUtil.loading) {
      setSaveUserStatus(StatusUtil.loading);
    }

    User user = User(
      id: id,
      name: name,
      role: roleTextField?.text,
      email: email,
      password: password,
    );

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
    User user =
        User(email: emailTextField.text, password: passwordTextField.text);
    ApiResponse apiResponse = await userServices.checkUserData(user);
    if (apiResponse.statusUtil == StatusUtil.success) {
      User? userData = apiResponse.data;
      if (userData != null) {
        UserData.userData = userData;
        isUserExists = true;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", userData.id.toString());
        prefs.setString("userName", userData.name.toString());
        prefs.setString("userEmail", userData.email.toString());
        prefs.setString("userRole", userData.role.toString());
      }
      setGetLoginUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetLoginUserStatus(StatusUtil.error);
    }
  }

  Future<void> deleteUserData() async {
    if (_getDeleteUserStatus != StatusUtil.loading) {
      setGetDeleteUserStatus(StatusUtil.loading);
    }
    userId = UserData.userData!.id;
    ApiResponse apiResponse = await userServices.deleteUserData(userId!);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessfullyUserDataDeleted = apiResponse.data;
      setGetDeleteUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetDeleteUserStatus(StatusUtil.error);
    }
  }

  saveLoginUserToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  rememberMe(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('email', emailTextField.text);
      await prefs.setString('password', passwordTextField.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  readRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailTextField.text = prefs.getString('email') ?? "";
    passwordTextField.text = prefs.getString('password') ?? "";
    notifyListeners();
  }
}

class UserData {
  static User? userData;
}
