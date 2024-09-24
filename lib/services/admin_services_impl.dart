import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/services/admin_services.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/string_const.dart';

class AdminServicesImpl implements AdminServices {
  bool isSuccess = false;
  @override
  Future<ApiResponse> saveProduct(Product product) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("products")
            .add(product.toJson())
            .then((value) {
          isSuccess = true;
        });
        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }
}
