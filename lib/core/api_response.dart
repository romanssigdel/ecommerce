import 'package:ecommerce/core/status_util.dart';

class ApiResponse {
  StatusUtil? statusUtil;
  dynamic data;
  String? errorMessage;
  ApiResponse({this.data, this.errorMessage, this.statusUtil});
}
