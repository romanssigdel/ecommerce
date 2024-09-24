import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/services/admin_services.dart';
import 'package:ecommerce/services/admin_services_impl.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  String? productName, productDescription, productCategory, productPrice;
  String? errorMessage;
  String? isSuccess;
  TextEditingController? imageTextField;

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
}
