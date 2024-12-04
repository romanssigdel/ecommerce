import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/provider/user_provider.dart';

abstract class UserServices {
  Future<ApiResponse> saveUserData(User user);
  Future<ApiResponse> updateUserData(User user);
  Future<ApiResponse> getUserData();
  Future<ApiResponse> checkUserData(User user);
  Future<ApiResponse> deleteUserData(String id);
}
