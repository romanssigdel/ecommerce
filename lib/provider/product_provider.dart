import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/order.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/rate.dart';
import 'package:ecommerce/services/admin_services.dart';
import 'package:ecommerce/services/admin_services_impl.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  List<String> categoryImages = [
    "assets/images/mobile.png",
    "assets/images/laptop.png",
    "assets/images/printer.png",
    "assets/images/earbuds.png",
    "assets/images/smartwatch.png",
  ];
  List<String> categories = [
    "Mobilephone",
    "Laptop",
    "Printer",
    "Earbuds",
    "Smart Watches"
  ];

  String? id,
      productBrand,
      productName,
      productDescription,
      productQuantity,
      productCategory,
      productPrice,
      model,
      cpu,
      opertingSystem,
      memory,
      storage,
      screen,
      graphics,
      wirelessConnectivity,
      camera,
      warranty;
  String? errorMessage;
  String? userEmailforOrder;
  String? availableQuantity;

  String? isSuccess;
  bool? isSuccessProductInCart;
  bool? updateSuccess;
  bool? isAlreadyRated;
  bool? hasPurchasedProduct;

  bool? isSuccessfullyProductDeleted;
  TextEditingController? imageTextField;
  List<Product> productslist = [];
  List<Cart> cartList = [];
  List<Orders> orderList = [];

  // Map<String, List<double>> ratingList = {};
  // Map<String, List<int>> totalNoOfRatings = {};

  Map<String, Map<String, dynamic>> productRatings = {};

  // Rating controller text
  TextEditingController ratingController = TextEditingController();

  void setRating(String value) {
    ratingController.text = value;
    notifyListeners();
  }

//total price calculator of the cart
  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartList) {
      total += double.tryParse(item.price ?? '0') ?? 0.0;
    }
    return total;
  }

  setProductImage(value) {
    imageTextField = TextEditingController(text: value);
  }

  AdminServices adminServices = AdminServicesImpl();
  setProductId(String value) {
    id = value;
    notifyListeners();
  }

  setProductBrand(String value) {
    productBrand = value;
    notifyListeners();
  }

  setProductName(String value) {
    productName = value;
    notifyListeners();
  }

  setProductQuantity(String value) {
    productQuantity = value;
    notifyListeners();
  }

  setProductCategory(String value) {
    productCategory = value;
    notifyListeners();
  }

  setProductPrice(String value) {
    productPrice = value;
    notifyListeners();
  }

  setProductDescription(String value) {
    productDescription = value;
    notifyListeners();
  }

  setModel(String value) {
    model = value;
    notifyListeners();
  }

  setCpu(String value) {
    cpu = value;
    notifyListeners();
  }

  setOperatingSystem(String value) {
    opertingSystem = value;
    notifyListeners();
  }

  setMemory(String value) {
    memory = value;
    notifyListeners();
  }

  setStorage(String value) {
    storage = value;
    notifyListeners();
  }

  setScreen(String value) {
    screen = value;
    notifyListeners();
  }

  setGraphics(String value) {
    graphics = value;
    notifyListeners();
  }

  setWirelessConnectivity(String value) {
    wirelessConnectivity = value;
    notifyListeners();
  }

  setCamera(String value) {
    camera = value;
    notifyListeners();
  }

  setWaranty(String value) {
    warranty = value;
    notifyListeners();
  }

  setSaveStatusProductName(StatusUtil status) {
    _saveProductStatus = status;
    notifyListeners();
  }

  setUpdateProduct(StatusUtil statusUtil) {
    _updateProductStatus = statusUtil;
    notifyListeners();
  }

  StatusUtil? _saveProductStatus = StatusUtil.none;
  StatusUtil? get saveProductStatus => _saveProductStatus;

  StatusUtil? _getProductStatus = StatusUtil.none;
  StatusUtil? get getProductStatus => _getProductStatus;

  StatusUtil? _deleteProductStatus = StatusUtil.none;
  StatusUtil? get deleteProductStatus => _deleteProductStatus;

  StatusUtil? _updateProductStatus = StatusUtil.none;
  StatusUtil? get updateProductStatus => _updateProductStatus;

  StatusUtil? _saveProductToCart = StatusUtil.none;
  StatusUtil? get saveProductToCart => _saveProductToCart;

  StatusUtil? _getProductCart = StatusUtil.none;
  StatusUtil? get getProductCart => _getProductCart;

  StatusUtil? _getUpdateQuantity = StatusUtil.none;
  StatusUtil? get getUpdateQuantity => _getUpdateQuantity;

  StatusUtil? _checkProductsInCart = StatusUtil.none;
  StatusUtil? get checkProductsInCart => _checkProductsInCart;

  StatusUtil? _deleteProductsInCart = StatusUtil.none;
  StatusUtil? get deleteProductsInCart => _deleteProductsInCart;

  StatusUtil? _saveSoldProductStatus = StatusUtil.none;
  StatusUtil? get saveSoldProductStatus => _saveSoldProductStatus;

  StatusUtil? _saveDeleteAfterPaymentStatus = StatusUtil.none;
  StatusUtil? get saveDeleteAfterPaymentStatus => _saveDeleteAfterPaymentStatus;

  StatusUtil? _getOrderFromCart = StatusUtil.none;
  StatusUtil? get getOrderFromCart => _getOrderFromCart;

  StatusUtil? _addRatingToProduct = StatusUtil.none;
  StatusUtil? get addRatingToProduct => _addRatingToProduct;

  StatusUtil? _checkRatingOfProduct = StatusUtil.none;
  StatusUtil? get checkRatingOfProduct => _checkRatingOfProduct;

  StatusUtil? _checkOrderForBoughtProduct = StatusUtil.none;
  StatusUtil? get checkOrderForBoughtProduct => _checkOrderForBoughtProduct;

  StatusUtil? _getUserEmailForOrder = StatusUtil.none;
  StatusUtil? get getUserEmailForOrder => _getUserEmailForOrder;

  setgetUpdateQuantity(StatusUtil statusUtil) {
    _getUpdateQuantity = statusUtil;
    notifyListeners();
  }

  setgetProductCart(StatusUtil statusUtil) {
    _getProductCart = statusUtil;
    notifyListeners();
  }

  setSaveProductToCart(StatusUtil statusUtil) {
    _saveProductToCart = statusUtil;
    notifyListeners();
  }

  setDeleteProductFromCart(StatusUtil statusUtil) {
    _deleteProductsInCart = statusUtil;
    notifyListeners();
  }

  setDeleteStatus(StatusUtil statusUtil) {
    _deleteProductStatus = statusUtil;
    notifyListeners();
  }

  setGetStatusProduct(StatusUtil statusUtil) {
    _getProductStatus = statusUtil;
    notifyListeners();
  }

  setGetProductInCart(StatusUtil statusUtil) {
    _checkProductsInCart = statusUtil;
    notifyListeners();
  }

  setSaveSoldProductToCart(StatusUtil statusUtil) {
    _saveSoldProductStatus = statusUtil;
    notifyListeners();
  }

  setSaveDeleteProductAfterPayment(StatusUtil statusUtil) {
    _saveDeleteAfterPaymentStatus = statusUtil;
    notifyListeners();
  }

  setGetOrderFromCart(StatusUtil statusUtil) {
    _getOrderFromCart = statusUtil;
    notifyListeners();
  }

  setAddRatingToProduct(StatusUtil statusUtil) {
    _addRatingToProduct = statusUtil;
    notifyListeners();
  }

  setCheckRatingOfProduct(StatusUtil statusUtil) {
    _checkRatingOfProduct = statusUtil;
    notifyListeners();
  }

  setCheckForBoughtProduct(StatusUtil statusUtil) {
    _checkOrderForBoughtProduct = statusUtil;
    notifyListeners();
  }

  setGetUserEmailForOrder(StatusUtil statusUtil) {
    _getUserEmailForOrder = statusUtil;
    notifyListeners();
  }

  Future<void> saveProduct() async {
    if (_saveProductStatus != StatusUtil.loading) {
      setSaveStatusProductName(StatusUtil.loading);
    }
    Product product = Product(
        id: id,
        brand: productBrand,
        name: productName,
        quantity: productQuantity,
        image: imageTextField!.text,
        price: productPrice,
        category: productCategory,
        model: model,
        cpu: cpu,
        operatingSystem: opertingSystem,
        memory: memory,
        storage: storage,
        screen: screen,
        graphics: graphics,
        wirelessConnectivity: wirelessConnectivity,
        camera: camera,
        warranty: warranty,
        description: productDescription);
    ApiResponse response = await adminServices.saveProduct(product);
    if (response.statusUtil == StatusUtil.success) {
      setSaveStatusProductName(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setSaveStatusProductName(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> updateProduct(String id) async {
    if (_updateProductStatus != StatusUtil.loading) {
      setUpdateProduct(StatusUtil.loading);
    }
    Product product = Product(
        id: id,
        name: productName,
        quantity: productQuantity,
        image: imageTextField!.text,
        price: productPrice,
        category: productCategory,
        model: model,
        cpu: cpu,
        operatingSystem: opertingSystem,
        memory: memory,
        storage: storage,
        screen: screen,
        graphics: graphics,
        wirelessConnectivity: wirelessConnectivity,
        camera: camera,
        warranty: warranty,
        description: productDescription);
    ApiResponse response = await adminServices.updateProduct(id, product);
    if (response.statusUtil == StatusUtil.success) {
      setUpdateProduct(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setUpdateProduct(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> getProduct() async {
    if (_getProductStatus != StatusUtil.loading) {
      setGetStatusProduct(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.getProduct();
    if (apiResponse.statusUtil == StatusUtil.success) {
      productslist = apiResponse.data;
      setGetStatusProduct(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setGetStatusProduct(StatusUtil.error);
    }
  }

  Future<void> deleteProduct(String id) async {
    if (_deleteProductStatus != StatusUtil.loading) {
      setDeleteStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.deleteProduct(id);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessfullyProductDeleted = apiResponse.data;
      setDeleteStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setDeleteStatus(StatusUtil.error);
    }
  }

  Future<void> saveProductCart(Cart cart) async {
    if (_saveProductToCart != StatusUtil.loading) {
      setSaveProductToCart(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.addProductToCart(cart);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccess = apiResponse.data;
      setSaveProductToCart(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setSaveProductToCart(StatusUtil.error);
    }
  }

  Future<void> getFromProductCart() async {
    if (_getProductCart != StatusUtil.loading) {
      setgetProductCart(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.getProductFromCart();
    if (apiResponse.statusUtil == StatusUtil.success) {
      cartList = apiResponse.data;
      setgetProductCart(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setgetProductCart(StatusUtil.error);
    }
  }

  Future<void> updateQuantity(Cart cart) async {
    if (_getUpdateQuantity != StatusUtil.loading) {
      setgetUpdateQuantity(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.updateProductQuantity(cart);
    if (apiResponse.statusUtil == StatusUtil.success) {
      updateSuccess = apiResponse.data;
      setgetUpdateQuantity(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setgetUpdateQuantity(StatusUtil.error);
    }
  }

  Future<void> deleteProductCart(String id, String userId) async {
    if (_deleteProductsInCart != StatusUtil.loading) {
      setDeleteStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse =
        await adminServices.deleteProductFromCart(id, userId);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessfullyProductDeleted = apiResponse.data;
      setDeleteProductFromCart(StatusUtil.success);
      notifyListeners();
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setDeleteProductFromCart(StatusUtil.error);
    }
  }

  Future<void> checkProductInCart(Cart cart) async {
    if (_checkProductsInCart != StatusUtil.loading) {
      setGetProductInCart(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.checkProductInCart(cart);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessProductInCart = apiResponse.data;
      setGetProductInCart(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      setGetProductInCart(StatusUtil.error);
    }
  }

  Future<void> saveSoldProduct(List<dynamic> userCartList, String userId,
      String userEmail, String totalPrice) async {
    if (_saveSoldProductStatus != StatusUtil.loading) {
      setSaveSoldProductToCart(StatusUtil.loading);
    }
    ApiResponse response = await adminServices.sendUserCartListToFirestore(
        userCartList, userId, userEmail, totalPrice);
    if (response.statusUtil == StatusUtil.success) {
      setSaveSoldProductToCart(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setSaveSoldProductToCart(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> deleteCartAfterPayment(String userId) async {
    if (_saveDeleteAfterPaymentStatus != StatusUtil.loading) {
      setSaveDeleteProductAfterPayment(StatusUtil.loading);
    }
    ApiResponse apiResponse =
        await adminServices.deleteCartAfterPayment(userId);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessfullyProductDeleted = apiResponse.data;
      setSaveDeleteProductAfterPayment(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setSaveDeleteProductAfterPayment(StatusUtil.error);
    }
  }

  Future<void> getOrdersFromCart() async {
    if (_getOrderFromCart != StatusUtil.loading) {
      setGetOrderFromCart(StatusUtil.loading);
    }
    try {
      ApiResponse apiResponse =
          await adminServices.getUserOrdersFromFirestore();
      if (apiResponse.statusUtil == StatusUtil.success) {
        orderList = apiResponse.data;
        setGetOrderFromCart(StatusUtil.success);
      } else if (apiResponse.statusUtil == StatusUtil.error) {
        errorMessage = apiResponse.errorMessage;
        setGetOrderFromCart(StatusUtil.error);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addRatingToProducts(Rate rate) async {
    if (_addRatingToProduct != StatusUtil.loading) {
      setAddRatingToProduct(StatusUtil.loading);
    }
    ApiResponse response = await adminServices.addRatingToProduct(rate);
    if (response.statusUtil == StatusUtil.success) {
      setAddRatingToProduct(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setAddRatingToProduct(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> checkRatingOfProducts(String id, String userId) async {
    if (_checkRatingOfProduct != StatusUtil.loading) {
      setCheckRatingOfProduct(StatusUtil.loading);
    }
    ApiResponse response = await adminServices.checkRatingOfProduct(id, userId);

    if (response.statusUtil == StatusUtil.success) {
      isAlreadyRated = response.data;
      setCheckRatingOfProduct(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setCheckRatingOfProduct(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> checkOrderForBoughtProducts(
      String productId, String userId) async {
    if (_checkOrderForBoughtProduct != StatusUtil.loading) {
      setCheckForBoughtProduct(StatusUtil.loading);
    }
    ApiResponse response =
        await adminServices.checkIfUserPurchasedProduct(productId, userId);

    if (response.statusUtil == StatusUtil.success) {
      hasPurchasedProduct = response.data;
      setCheckForBoughtProduct(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setCheckForBoughtProduct(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> getUserEmailForOrders(String userId) async {
    if (_getUserEmailForOrder != StatusUtil.loading) {
      setGetUserEmailForOrder(StatusUtil.loading);
    }
    ApiResponse response = await adminServices.getUserEmailForOrders(userId);
    if (response.statusUtil == StatusUtil.success) {
      userEmailforOrder = response.data;
      setGetUserEmailForOrder(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setGetUserEmailForOrder(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }

  Future<void> calculateAverageRating(String productId) async {
    try {
      // Fetch ratings for the specific product
      QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
          .collection("rating")
          .where("productId", isEqualTo: productId)
          .get();

      if (ratingSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        int count = 0;

        // Calculate total rating and count the number of ratings
        for (var doc in ratingSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          totalRating += double.parse(data["rating"]);
          count++;
        }

        // Calculate average rating
        double average = totalRating / count;

        // Store the average and total number of reviews in the productRatings map
        productRatings[productId] = {
          'average': average,
          'count': count,
        };
      } else {
        // Default values if no ratings are available
        productRatings[productId] = {
          'average': 0.0,
          'count': 0,
        };
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error calculating average rating: $e");
    }
  }

  Future<void> updateProductStock(
      String productId, int purchasedQuantity) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Get the document for the specific product
      DocumentSnapshot productSnapshot =
          await firestore.collection('products').doc(productId).get();

      // Check if the product exists
      if (productSnapshot.exists) {
        Map<String, dynamic> productData =
            productSnapshot.data() as Map<String, dynamic>;

        // Get the current stock quantity
        int currentStock =
            int.tryParse(productData['quantity'].toString()) ?? 0;

        // Calculate the new quantity
        int newStock = currentStock - purchasedQuantity;

        // Ensure stock doesn't go below zero
        if (newStock < 0) newStock = 0;

        // Update the product quantity in Firestore
        await firestore
            .collection('products')
            .doc(productId)
            .update({'quantity': newStock.toString()});
      }
    } catch (e) {
      print('Error updating product stock: $e');
    }
  }

  Future<void> getAvailableQuantity(String productId) async {
    ApiResponse apiResponse =
        await adminServices.getAvailableProductQuantity(productId);
    if (apiResponse.statusUtil == StatusUtil.success) {
      availableQuantity = apiResponse.data;
    } else {
      errorMessage = apiResponse.errorMessage;
    }
  }

  double _priceToDouble(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      // remove non-numeric except dot, then parse
      final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  double calculateSimilarityScore(Product current, Product other) {
    double score = 0;

    if (current.category == other.category) {
      score += 0.5; // weight for category
    }

    if (current.brand == other.brand) {
      score += 0.3; // weight for brand
    }

    final double p1 = _priceToDouble(current.price);
    final double p2 = _priceToDouble(other.price);
    final double priceDifference = (p1 - p2).abs();

    if (priceDifference <= 10000) {
      // within Rs.1000 price range
      score += 0.2;
    }

    return score; // max score = 1.0
  }

  Future<List<Product>> getRecommendedProductsManually(
      Product currentProduct) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    List<Product> allProducts = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // 🔥 Attach Firestore ID
      return Product.fromJson(data);
    }).toList();

    // Remove the current product
    allProducts.removeWhere((p) => p.id == currentProduct.id);

    // Calculate score for each product
    List<Map<String, dynamic>> scoredProducts = allProducts.map((product) {
      double score = calculateSimilarityScore(currentProduct, product);
      return {'product': product, 'score': score};
    }).toList();

    // Sort by highest score
    scoredProducts.sort((a, b) => b['score'].compareTo(a['score']));

    // Return top 5
    return scoredProducts.take(5).map((e) => e['product'] as Product).toList();
  }
}
