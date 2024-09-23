import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/services/admin_services.dart';
import 'package:ecommerce/services/admin_services_impl.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  String? productName, productImage, productDescription;
  double? productPrice;
  String? errorMessage;
  String? isSuccess;

  AdminServices adminServices = AdminServicesImpl();
  setProductName(String value) {
    productName = value;
  }

  setProductPrice(double value) {
    productPrice = value;
  }

  setProductImage(String value) {
    productImage = value;
  }

  setProducctDescription(String value) {
    productDescription = value;
  }

  setSaveStatusProductName(StatusUtil status) {
    _saveProductStatus = status;
  }

  StatusUtil? _saveProductStatus = StatusUtil.none;
  StatusUtil? get saveProductStatus => _saveProductStatus;

  Future<void> saveProduct() async {
    if (_saveProductStatus != StatusUtil.loading) {
      setSaveStatusProductName(StatusUtil.loading);
    }
    Product product = Product(
        name: productName,
        image: productImage,
        price: productPrice,
        description: productDescription);
    ApiResponse response = await adminServices.saveProduct(product);
    if (response.statusUtil == StatusUtil.success) {
      setSaveStatusProductName(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      setSaveStatusProductName(StatusUtil.error);
      errorMessage = response.errorMessage;
    }
  }
}
