import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';

abstract class AdminServices {
  Future<ApiResponse> saveProduct(Product product);
  Future<ApiResponse> getProduct();
  Future<ApiResponse> deleteProduct(String id);
  Future<ApiResponse> updateProduct(Product product);
  Future<ApiResponse> addProductToCart(Cart cart);
  Future<ApiResponse> getProductFromCart();
  Future<ApiResponse> updateProductQuantity(Cart cart);
  Future<ApiResponse> deleteProductFromCart(String id);

  //Checks if the cart doesnot have any redundancy
  // User should not be able to add if the product is already added to the cart.
  Future<ApiResponse> checkProductInCart(Cart cart);

  // Future<ApiResponse> addSoldProductToCart(Cart cart);
  Future<ApiResponse> sendUserCartListToFirestore(
      List<dynamic> userCartList, String userId, String totalPrice);

  Future<ApiResponse> deleteCartAfterPayment(String userId);
  Future<ApiResponse> getUserOrdersFromFirestore();
}
