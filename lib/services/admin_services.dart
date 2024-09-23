import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/product.dart';

abstract class AdminServices {
  Future<ApiResponse> saveProduct(Product product);
}
