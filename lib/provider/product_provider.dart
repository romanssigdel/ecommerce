import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
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
    "Mobile",
    "Laptop",
    "Printer",
    "Earbuds",
    "Smart Watches"
  ];

  String? productName, productDescription, productCategory, productPrice;
  String? errorMessage;
  String? isSuccess;
  String? isSuccessfullyProductDeleted;
  TextEditingController? imageTextField;
  List<Product> productslist = [];

  setProductImage(value) {
    imageTextField = TextEditingController(text: value);
  }

  AdminServices adminServices = AdminServicesImpl();
  setProductName(String value) {
    productName = value;
  }

  setProductCategory(String value) {
    productCategory = value;
  }

  setProductPrice(String value) {
    productPrice = value;
  }

  setProducctDescription(String value) {
    productDescription = value;
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
        name: productName,
        image: imageTextField!.text,
        price: productPrice,
        description: productDescription,
        category: productCategory);
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
}
