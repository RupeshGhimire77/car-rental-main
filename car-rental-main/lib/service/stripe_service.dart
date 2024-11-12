import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/book_car.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<bool> makePayment(
      BuildContext context, BookCar booking, String price, String email) async {
    try {
      int? rentalDays = rentalPeriod(booking.startDate!, booking.endDate!);
      String? paymentIntentClientSecret = await _createPaymentIntent(
          rentalDays, int.parse(price), "npr", email);
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
      int rentalDays, int amount, String currency, String email) async {
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

      int totalAmount = calculateTotalPrice(rentalDays, amount);

      // Step 2: Create the payment intent with the customer ID
      Map<String, dynamic> data = {
        "amount": _calculateAmount(totalAmount),
        // "amount": totalAmount,
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

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment sheet presented successfully.");
    } catch (e) {
      print("Error presenting payment sheet: $e");
    }
  }

  int calculateTotalPrice(int rentalDays, int dailyRate) {
    if (rentalDays <= 3) {
      // Full price for 3 days or less
      return rentalDays * dailyRate;
    } else {
      // Calculate for first 3 days at full price
      int totalPrice = 3 * dailyRate;

      double discount = 5;

      // Starting discount from the 4th day
      for (int day = 4; day <= rentalDays; day++) {
        // Apply discount to the daily rate
        double discountedRate = dailyRate * (1 - discount / 100);
        totalPrice += discountedRate.toInt();

        // Increase discount by 1% for each day past the 4th
        discount += 1;
      }

      return totalPrice;
    }
  }

  String _calculateAmount(int amount) {
    return (amount * 100).toString(); // Convert to cents
  }

  int rentalPeriod(String startDate, String endDate) {
    // Parsing the start and end dates
    NepaliDateTime start = NepaliDateTime.parse(startDate);
    NepaliDateTime end = NepaliDateTime.parse(endDate);

    // Calculating the difference in days
    int totalRentalDays = end.difference(start).inDays;
    return totalRentalDays;
  }
}
