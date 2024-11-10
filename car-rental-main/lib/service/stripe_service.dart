import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  // Future<bool> makePayment(Car car, String email) async {
  //   try {
  //     String? paymentIntentClientSecret =
  //         await _createPaymentIntent(int.parse(car.rentalPrice!), "usd", email);
  //     if (paymentIntentClientSecret == null) return false;

  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentClientSecret,
  //         merchantDisplayName: "Rupesh Ghimire",
  //       ),
  //     );

  //     await Stripe.instance.presentPaymentSheet();
  //     return true; // Return true if payment was successful
  //   } catch (e) {
  //     print("Payment failed: $e");
  //     return false; // Return false if there was an error
  //   }
  // }

  Future<bool> makePayment(BuildContext context, Car car, String email) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(int.parse(car.rentalPrice!), "npr", email);
      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Rupesh Ghimire",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Show the email of the payer after successful payment
      _showEmail(context, email);

      return true; // Return true if payment was successful
    } catch (e) {
      print("Payment failed: $e");
      return false; // Return false if there was an error
    }
  }

  void _showEmail(BuildContext context, String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful! Receipt sent to: $email'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<String?> _createPaymentIntent(
      int amount, String currency, String email) async {
    try {
      final Dio dio = Dio();

      // Step 1: Create a customer
      var customerResponse = await dio.post(
        "https://api.stripe.com/v1/customers",
        data: {
          "email": email,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      String customerId = customerResponse.data["id"]; // Get the customer ID

      // Step 2: Create the payment intent with the customer ID
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
        "customer":
            customerId, // Associate the customer with the payment intent
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Error creating Payment Intent: $e");
    }
    return null;
  }

  // Future<String?> _createPaymentIntent(
  //     int amount, String currency, String email) async {
  //   try {
  //     final Dio dio = Dio();
  //     Map<String, dynamic> data = {
  //       "amount": _calculateAmount(amount),
  //       "currency": currency,
  //       "receipt_email": email, // Add email here
  //     };

  //     var response = await dio.post(
  //       "https://api.stripe.com/v1/payment_intents",
  //       data: data,
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //         headers: {
  //           "Authorization": "Bearer $stripeSecretKey",
  //           "Content-Type": 'application/x-www-form-urlencoded'
  //         },
  //       ),
  //     );

  //     if (response.data != null) {
  //       return response.data["client_secret"];
  //     }
  //     return null;
  //   } catch (e) {
  //     print("Error creating Payment Intent: $e");
  //   }
  //   return null;
  // }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment sheet presented successfully.");
    } catch (e) {
      print("Error presenting payment sheet: $e");
    }
  }

  String _calculateAmount(int amount) {
    return (amount * 100).toString(); // Convert to cents
  }
}
