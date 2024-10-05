import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/product.dart';

abstract class AdminServices {
  Future<ApiResponse> saveProduct(Product product);
  Future<ApiResponse> getProduct();
  Future<ApiResponse> deleteProduct(String id);
  Future<ApiResponse> updateProduct(Product product);
}
