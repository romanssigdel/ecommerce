import 'package:ecommerce/core/status_util.dart';

class ApiResponse {
  StatusUtil? statusUtil;
  dynamic data;
  String? errorMessage;
  String? role;
  ApiResponse({this.role,this.data, this.errorMessage, this.statusUtil});
}
