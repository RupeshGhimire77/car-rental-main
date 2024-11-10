import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/stripe_service.dart';
import 'package:flutter_application_1/shared/custom_button.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
              onPressed: () {
                // StripeService.instance.makePayment();
              },
              child: Text("pay"))
        ],
      ),
    );
  }
}
