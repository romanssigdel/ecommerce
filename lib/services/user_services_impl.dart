import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/services/user_services.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/string_const.dart';

class UserServicesImplementation extends UserServices {
  List<User> userList = [];
  bool isSuccessfullyDeleted = false;

  @override
  Future<ApiResponse> saveUserData(User user) async {
    bool isSuccess = false;
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .add(user.toJson())
            .then((value) {
          isSuccess = true;
        });
        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> getUserData() async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        var value = await FirebaseFirestore.instance.collection("users").where("role",isEqualTo: "user").get();
        var userList = value.docs.map((e) => User.fromJson(e.data())).toList();
        for (int i = 0; i < userList.length; i++) {
          userList[i].id = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: userList);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> checkUserData(User user) async {
    // bool isUserExists = false;
    User? userData;
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: user.email)
            .where("password", isEqualTo: user.password)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            // isUserExists = true
            userData = User.fromJson(value.docs[0].data());
          }
        });
        // UserCheckResult result = UserCheckResult(userData, isUserExists);
        return ApiResponse(statusUtil: StatusUtil.success, data: userData);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> deleteUserData(String id) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .delete()
            .then((value) {
          isSuccessfullyDeleted = true;
        });
        return ApiResponse(
            statusUtil: StatusUtil.success, data: isSuccessfullyDeleted);
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConectionStr);
    }
  }
}
