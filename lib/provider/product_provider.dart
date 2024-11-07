import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
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
  bool? updateSuccess;
  bool? isSuccessfullyProductDeleted;
  TextEditingController? imageTextField;
  List<Product> productslist = [];
  List<Cart> cartList = [];

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

  setDeleteStatus(StatusUtil statusUtil) {
    _deleteProductStatus = statusUtil;
    notifyListeners();
  }

  setGetStatusProduct(StatusUtil statusUtil) {
    _getProductStatus = statusUtil;
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

  Future<void> deleteProductCart(String id) async {
    if (_deleteProductStatus != StatusUtil.loading) {
      setDeleteStatus(StatusUtil.loading);
    }
    ApiResponse apiResponse = await adminServices.deleteProductFromCart(id);
    if (apiResponse.statusUtil == StatusUtil.success) {
      isSuccessfullyProductDeleted = apiResponse.data;
      setDeleteStatus(StatusUtil.success);
    } else if (apiResponse.statusUtil == StatusUtil.error) {
      errorMessage = apiResponse.errorMessage;
      setDeleteStatus(StatusUtil.error);
    }
  }
}
