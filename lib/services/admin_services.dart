import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/rate.dart';

abstract class AdminServices {
  Future<ApiResponse> saveProduct(Product product);
  Future<ApiResponse> getProduct();
  Future<ApiResponse> deleteProduct(String id);
  Future<ApiResponse> updateProduct(String id, Product product);
  Future<ApiResponse> addProductToCart(Cart cart);
  Future<ApiResponse> getProductFromCart();
  Future<ApiResponse> updateProductQuantity(Cart cart);
  Future<ApiResponse> deleteProductFromCart(String id, String userId);

  //Checks if the cart doesnot have any redundancy
  // User should not be able to add if the product is already added to the cart.
  Future<ApiResponse> checkProductInCart(Cart cart);

  // Future<ApiResponse> addSoldProductToCart(Cart cart);
  Future<ApiResponse> sendUserCartListToFirestore(
      List<dynamic> userCartList, String userId,String userEmail, String totalPrice);

  Future<ApiResponse> deleteCartAfterPayment(String useraId);
  Future<ApiResponse> getUserOrdersFromFirestore();

  // Adding rating to the product
  Future<ApiResponse> addRatingToProduct(Rate rate);

  Future<ApiResponse> checkRatingOfProduct(String id, String userId);

  Future<ApiResponse> checkIfUserPurchasedProduct(
      String productId, String userId);

  Future<ApiResponse> getUserEmailForOrders(String userId);
  Future<ApiResponse> getAvailableProductQuantity(String productId); 
}
