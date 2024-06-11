import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/user.dart';

abstract class UserServices{
  Future<ApiResponse> saveUserData(User user);
}