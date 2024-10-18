import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';

class MobileNoOTP extends StatefulWidget {
  const MobileNoOTP({super.key});

  @override
  State<MobileNoOTP> createState() => _MobileNoOTPState();
}

class _MobileNoOTPState extends State<MobileNoOTP> {
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF771616),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 20),
              child: Text(
                "Forget Password",
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Text(
                "Recover Password",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 2),
              child: CustomTextFormField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                hintText: " Enter Your Mobile Number",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: CustomButton(
                  onPressed: () async {
                    // await FirebaseAuth.instance.verifyPhoneNumber(
                    //   phoneNumber: '+977$phoneNumber',
                    //   verificationCompleted:
                    //       (PhoneAuthCredential credential) {},
                    //   verificationFailed: (FirebaseAuthException e) {},
                    //   codeSent: (String verificationId, int? resendToken) {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => OTP(
                    //             verificationId: verificationId,
                    //           ),
                    //         ));
                    //   },
                    //   codeAutoRetrievalTimeout: (String verificationId) {},
                    // );
                  },
                  child: Text(
                    "Recover",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
