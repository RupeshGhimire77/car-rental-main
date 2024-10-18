import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Helper {
  static Future<bool> isInternetConnectionAvailable() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static displaySnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
