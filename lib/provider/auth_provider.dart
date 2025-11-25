import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/services/auth_services.dart';
import 'package:ecommerce/services/auth_services_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool isSuccess = false;
  String? errorMessage;

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController confirmPasswordTextField = TextEditingController();
  TextEditingController newPasswordTextField = TextEditingController();
  TextEditingController currentPasswordTextField = TextEditingController();
  TextEditingController newUsernameTextField = TextEditingController();

  TextEditingController roleTextField = TextEditingController(text: "user");

  AuthServices authServices = AuthServicesImplementation();

  Stream<User?> get authStateChanges => authServices.authStateChanges;
  User? get currentUser => authServices.currentUser;

  StatusUtil _saveUserStatus = StatusUtil.none;
  StatusUtil get saveUserStatus => _saveUserStatus;

  setSaveUserStatus(StatusUtil statusUtil) {
    _saveUserStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getLoginUserStatus = StatusUtil.none;
  StatusUtil get getLoginUserStatus => _getLoginUserStatus;

  setGetLoginUserStatus(StatusUtil statusUtil) {
    _getLoginUserStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getLogoutUserStatus = StatusUtil.none;
  StatusUtil get getLogoutUserStatus => _getLogoutUserStatus;

  setGetLogoutUserStatus(StatusUtil statusUtil) {
    _getLogoutUserStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getResetUserPasswordStatus = StatusUtil.none;
  StatusUtil get getResetUserPasswordStatus => _getResetUserPasswordStatus;

  setGetResetUserPasswordStatus(StatusUtil statusUtil) {
    _getResetUserPasswordStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getUpdateUsernameStatus = StatusUtil.none;
  StatusUtil get getUpdateUsernametatus => _getUpdateUsernameStatus;

  setGetUpdateUsernameStatus(StatusUtil statusUtil) {
    _getUpdateUsernameStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getResetUserPasswordFromCurrentPasswordStatus = StatusUtil.none;
  StatusUtil get getResetUserPasswordFromCurrentPasswordStatus =>
      _getResetUserPasswordFromCurrentPasswordStatus;

  setGetResetUserPasswordFromCurrentPasswordStatus(StatusUtil statusUtil) {
    _getResetUserPasswordFromCurrentPasswordStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil _getdeleteAccountStatus = StatusUtil.none;
  StatusUtil get getdeleteAccountstatus => _getdeleteAccountStatus;

  setGetdeleteAccountStatus(StatusUtil statusUtil) {
    _getdeleteAccountStatus = statusUtil;
    notifyListeners();
  }

  Future<void> signupUser() async {
    if (_saveUserStatus != StatusUtil.loading) {
      setSaveUserStatus(StatusUtil.loading);
    }

    ApiResponse apiResponse = await authServices.createAccount(
        email: emailTextField.text,
        password: passwordTextField.text,
        role: roleTextField.text);

    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setSaveUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setSaveUserStatus(StatusUtil.error);
    }
  }

  Future<void> loginUser() async {
    if (_getLoginUserStatus != StatusUtil.loading) {
      setGetLoginUserStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await authServices.signIn(
        email: emailTextField.text, password: passwordTextField.text);
    if (apiResponse.statusUtil == StatusUtil.success) {
      UserCredential userCredential = apiResponse.data;
      if (userCredential.user != null) {}
      setGetLoginUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetLoginUserStatus(StatusUtil.error);
    }
  }

  Future<void> logoutUser() async {
    if (_getLogoutUserStatus != StatusUtil.loading) {
      setGetLogoutUserStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await authServices.signOut();
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setGetLogoutUserStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetLogoutUserStatus(StatusUtil.error);
    }
  }

  Future<void> resetUserPassword() async {
    if (_getResetUserPasswordStatus != StatusUtil.loading) {
      setGetResetUserPasswordStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse =
        await authServices.resetPassword(email: emailTextField.text);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setGetResetUserPasswordStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetResetUserPasswordStatus(StatusUtil.error);
    }
  }

  Future<void> resetUserPasswordFromCurrentPassword() async {
    if (_getResetUserPasswordFromCurrentPasswordStatus != StatusUtil.loading) {
      setGetResetUserPasswordFromCurrentPasswordStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse =
        await authServices.resetPasswordFromCurrentPassword(
      email: emailTextField.text,
      currentPassword: passwordTextField.text,
      newPassword: newPasswordTextField.text,
    );
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setGetResetUserPasswordFromCurrentPasswordStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetResetUserPasswordFromCurrentPasswordStatus(StatusUtil.error);
    }
  }

  Future<void> updateUsername() async {
    if (_getUpdateUsernameStatus != StatusUtil.loading) {
      setGetUpdateUsernameStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await authServices.updateUsername(
      username: newUsernameTextField.text,
    );
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setGetUpdateUsernameStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetUpdateUsernameStatus(StatusUtil.error);
    }
  }

  Future<void> deleteAccount() async {
    if (_getdeleteAccountStatus != StatusUtil.loading) {
      setGetdeleteAccountStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await authServices.deleteAccount(
        email: emailTextField.text, password: passwordTextField.text);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setGetdeleteAccountStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetdeleteAccountStatus(StatusUtil.error);
    }
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['role']; // Return role (admin, user)
  }

  Future<void> saveUserDataToFirestore(
      String uid, String email, String role, String timestamp) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'role': role,
      'createdAt': timestamp,
    }, SetOptions(merge: true));
  }

  // saveLoginUserToSharedPreference() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLogin', true);
  // }
}
