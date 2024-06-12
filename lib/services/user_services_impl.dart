import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/services/user_services.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/string_const.dart';

class UserServicesImplementation extends UserServices {
  List<User> userList = [];
  @override
  Future<ApiResponse> saveUserData(User user) async {
    bool isSuccess = false;
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("user")
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
        await FirebaseFirestore.instance.collection("user").get().then((value) {
          print(value);
          userList
              .addAll(value.docs.map((e) => User.fromJson(e.data())).toList());
          print(userList);
        });
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
    bool isUserExists = false;
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("user")
            .where("email", isEqualTo: user.email)
            .where("password", isEqualTo: user.password)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            isUserExists = true;
            print(value);
          }
        });
        return ApiResponse(statusUtil: StatusUtil.success, data: isUserExists);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConectionStr);
    }
  }
}
