import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Helper {
  Future<bool> isInternetConnectionAvailable() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  static displaySnackbar(BuildContext context, var message) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
