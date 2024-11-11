import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/cart.dart';
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

  @override
  Future<ApiResponse> getProduct() async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        var value =
            await FirebaseFirestore.instance.collection("products").get();
        var productList =
            value.docs.map((e) => Product.fromJson(e.data())).toList();
        for (int i = 0; i < productList.length; i++) {
          productList[i].id = value.docs[i].id;
        }

        return ApiResponse(statusUtil: StatusUtil.success, data: productList);
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> deleteProduct(String id) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(id)
            .delete()
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

  @override
  Future<ApiResponse> updateProduct(Product product) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(product.id)
            .update(product.toJson())
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
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> addProductToCart(Cart cart) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("cart")
            .add(cart.toJson())
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

  @override
  Future<ApiResponse> getProductFromCart() async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        var value = await FirebaseFirestore.instance.collection("cart").get();
        var cartList = value.docs.map((e) => Cart.fromJson(e.data())).toList();
        for (int i = 0; i < cartList.length; i++) {
          cartList[i].id = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: cartList);
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> updateProductQuantity(Cart cart) async {
    try {
      await FirebaseFirestore.instance
          .collection("cart")
          .doc(cart.id)
          .update(cart.toJson())
          .then((value) {
        isSuccess = true;
      });
      return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteProductFromCart(String id) async {
    // TODO: implement deleteProductFromCart
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("cart")
            .doc(id)
            .delete()
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

  @override
  Future<ApiResponse> checkProductInCart(Cart cart) async {
    // TODO: implement checkProductInCart
    bool isProductAlreadyExistInDatabase = false;
    try {
      var value = await FirebaseFirestore.instance
          .collection("cart")
          .where("id", isEqualTo: cart.id)
          .where("userId", isEqualTo: cart.userId)
          .get();
      if (value.docs.isNotEmpty) {
        isProductAlreadyExistInDatabase = true;
      }
      return ApiResponse(
          statusUtil: StatusUtil.success,
          data: isProductAlreadyExistInDatabase);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }
}
