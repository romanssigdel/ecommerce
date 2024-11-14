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
    "mobilephone",
    "laptop",
    "Printer",
    "Earbuds",
    "Smart Watches"
  ];

  String? id,
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
  String? isSuccess;
  bool? isSuccessProductInCart;
  bool? updateSuccess;
  bool? isAlreadyRated;

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

  StatusUtil? _saveProductStatus = StatusUtil.none;
  StatusUtil? get saveProductStatus => _saveProductStatus;

  StatusUtil? _getProductStatus = StatusUtil.none;
  StatusUtil? get getProductStatus => _getProductStatus;

  StatusUtil? _deleteProductStatus = StatusUtil.none;
  StatusUtil? get deleteProductStatus => _deleteProductStatus;

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

  StatusUtil? _getRatingOfProduct = StatusUtil.none;
  StatusUtil? get getRatingOfProduct => _getRatingOfProduct;

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

  setGetRatingOfProduct(StatusUtil statusUtil) {
    _getRatingOfProduct = statusUtil;
    notifyListeners();
  }

  Future<void> saveProduct() async {
    if (_saveProductStatus != StatusUtil.loading) {
      setSaveStatusProductName(StatusUtil.loading);
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
        warranty: warranty);
    ApiResponse response = await adminServices.saveProduct(product);
    if (response.statusUtil == StatusUtil.success) {
      setSaveStatusProductName(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setSaveStatusProductName(StatusUtil.error);
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

  Future<void> saveSoldProduct(
      List<dynamic> userCartList, String userId, String totalPrice) async {
    if (_saveSoldProductStatus != StatusUtil.loading) {
      setSaveSoldProductToCart(StatusUtil.loading);
    }
    ApiResponse response = await adminServices.sendUserCartListToFirestore(
        userCartList, userId, totalPrice);
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

  // Future<void> getRatingOfProducts() async {
  //   if (_getRatingOfProduct != StatusUtil.loading) {
  //     setGetRatingOfProduct(StatusUtil.loading);
  //   }
  //   ApiResponse response = await adminServices.getUserRatingOfProducts();

  //   if (response.statusUtil == StatusUtil.success) {
  //     ratingList = response.data;
  //     setGetRatingOfProduct(StatusUtil.success);
  //   } else if (response.statusUtil == StatusUtil.error) {
  //     setGetRatingOfProduct(StatusUtil.error);
  //     errorMessage = response.errorMessage;
  //   }
  // }

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
          'average': average, // Store average rating
          'count': count, // Store the number of ratings
        };
      } else {
        // Default values if no ratings are available
        productRatings[productId] = {
          'average': 0.0, // Default average
          'count': 0, // Default count
        };
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print("Error calculating average rating: $e");
    }
  }
}
