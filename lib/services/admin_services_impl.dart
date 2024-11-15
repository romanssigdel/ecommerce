import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/order.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/rate.dart';
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
  Future<ApiResponse> updateProduct(String id, Product product) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        // Fetch existing product data
        DocumentSnapshot existingProductSnapshot = await FirebaseFirestore
            .instance
            .collection("products")
            .doc(id)
            .get();

        // Convert the existing data to a map
        Map<String, dynamic> existingData =
            existingProductSnapshot.data() as Map<String, dynamic>;

        // Update the existing data with new values from `product.toJson()`
        existingData.addAll(product.toJson());

        // Save the updated data back to Firestore
        await FirebaseFirestore.instance
            .collection("products")
            .doc(id)
            .update(existingData)
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .where("id", isEqualTo: cart.id)
          .where("userId", isEqualTo: cart.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection("cart")
            .doc(docId)
            .update(cart.toJson());
      }
      return ApiResponse(statusUtil: StatusUtil.success, data: true);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteProductFromCart(String id, String userId) async {
    // TODO: implement deleteProductFromCart
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        // await FirebaseFirestore.instance.collection("cart").doc(id).delete();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("cart")
            .where('id', isEqualTo: id)
            .where("userId", isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            await FirebaseFirestore.instance
                .collection("cart")
                .doc(doc.id)
                .delete();
          }
        }

        return ApiResponse(statusUtil: StatusUtil.success, data: true);
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

  @override
  Future<ApiResponse> sendUserCartListToFirestore(List<dynamic> userCartList,
      String userId, String userEmail, String totalPrice) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in the 'orders' collection
      DocumentReference orderRef = firestore.collection('orders').doc();

      // Prepare the data to be saved
      Map<String, dynamic> orderData = {
        "userId": userId,
        "userEmail": userEmail,
        "totalAmount": totalPrice,
        "orderDate": DateTime.now(),
        "products": userCartList
            .map((product) => {
                  "id": product.id,
                  "name": product.name,
                  "price": product.price,
                  "quantity": product.quantity,
                  "image": product.image,
                })
            .toList(),
      };

      // Save the data to Firestore
      await orderRef.set(orderData);

      return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteCartAfterPayment(String userId) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection("cart")
            .where("userId", isEqualTo: userId)
            .get();

        // Check if any cart documents match the userId
        if (querySnapshot.docs.isNotEmpty) {
          // Loop through the documents and delete them
          for (var doc in querySnapshot.docs) {
            await FirebaseFirestore.instance
                .collection("cart")
                .doc(doc.id)
                .delete();
          }
        }
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
  Future<ApiResponse> getUserOrdersFromFirestore() async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        var value = await FirebaseFirestore.instance.collection("orders").get();
        var ordersList =
            value.docs.map((e) => Orders.fromJson(e.data())).toList();
        for (int i = 0; i < ordersList.length; i++) {
          ordersList[i].orderId = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: ordersList);
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }

  @override
  Future<ApiResponse> addRatingToProduct(Rate rate) async {
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("rating")
            .add(rate.toJson())
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
  Future<ApiResponse> checkRatingOfProduct(String id, String userId) async {
    if (id.isEmpty || userId.isEmpty) {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: "Invalid product or user ID");
    }

    if (await Helper().isInternetConnectionAvailable()) {
      try {
        // Fetch the documents that match both id and userId
        var value = await FirebaseFirestore.instance
            .collection("rating")
            .where("productId", isEqualTo: id)
            .where("userId", isEqualTo: userId)
            .get();

        // Debug: Check how many documents are returned
        print("Documents found: ${value.docs.length}");

        // If any document is found, it means the user has already rated the product
        if (value.docs.isNotEmpty) {
          // Debug: Print the data of the first document found
          print("Rating found: ${value.docs.first.data()}");

          return ApiResponse(statusUtil: StatusUtil.success, data: true);
        } else {
          return ApiResponse(statusUtil: StatusUtil.success, data: false);
        }
      } catch (e) {
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, data: noInternetConectionStr);
    }
  }

  // @override
  // Future<ApiResponse> checkIfUserPurchasedProduct(
  //     String productId, String userId) async {
  //   try {
  //     final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // Query the orders collection to check if the user has purchased the product
  //     QuerySnapshot querySnapshot = await firestore
  //         .collection('orders')
  //         .where('userId', isEqualTo: userId)
  //         .where('items.products.id', arrayContains: productId)
  //         .get();

  //     // Check if any orders contain the product
  //     bool hasPurchasedProduct = querySnapshot.docs.isNotEmpty;
  //     print(querySnapshot.docs);
  //     return ApiResponse(
  //       statusUtil: StatusUtil.success,
  //       data: hasPurchasedProduct,
  //     );
  //   } catch (e) {
  //     return ApiResponse(
  //       statusUtil: StatusUtil.error,
  //       errorMessage: e.toString(),
  //     );
  //   }
  // }
  @override
  Future<ApiResponse> checkIfUserPurchasedProduct(
      String productId, String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query Firestore to get all orders for the specified userId
      QuerySnapshot querySnapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      // Check if any order contains the productId in the products array
      List<QueryDocumentSnapshot> matchingOrders = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Check if 'products' field exists and is a list
        if (data['products'] != null && data['products'] is List) {
          List<dynamic> products = data['products'];

          // Check if any product in the list has the matching productId
          bool productFound = products.any((product) =>
              product is Map<String, dynamic> && product['id'] == productId);

          if (productFound) {
            matchingOrders.add(doc);
          }
        }
      }

      // Return the result as ApiResponse
      bool hasPurchasedProduct = matchingOrders.isNotEmpty;

      return ApiResponse(
        statusUtil: StatusUtil.success,
        data: hasPurchasedProduct,
      );
    } catch (e) {
      return ApiResponse(
        statusUtil: StatusUtil.error,
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse> getUserEmailForOrders(String userId) async {
    String? email;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        email = userDoc['email'];
      }
      return ApiResponse(statusUtil: StatusUtil.success, data: email);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> getAvailableProductQuantity(String productId) async {
    // Check if there is an internet connection available
    if (await Helper().isInternetConnectionAvailable()) {
      try {
        // Fetch the specific product document using its ID
        var documentSnapshot = await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .get();

        // Check if the document exists
        if (documentSnapshot.exists) {
          // Extract the quantity field from the product document
          String quantity = documentSnapshot.data()?['quantity'] ?? 0;

          // Return a success response with the quantity
          return ApiResponse(statusUtil: StatusUtil.success, data: quantity);
        } else {
          // If the product doesn't exist, return an error message
          return ApiResponse(
              statusUtil: StatusUtil.error, data: "Product not found");
        }
      } catch (e) {
        // Return an error response in case of an exception
        return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
      }
    } else {
      // Return an error response if there is no internet connection
      return ApiResponse(
          statusUtil: StatusUtil.error, data: "No internet connection");
    }
  }
}
