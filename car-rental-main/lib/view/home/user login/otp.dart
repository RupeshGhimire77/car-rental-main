import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTP extends StatelessWidget {
  OTP({super.key, this.verificationId});
  String? verificationId;
  String smsCode = "";
  // FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: Text(
              "Code has been Sent to +9779898989898",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("for Verification", style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                smsCode = smsCode + code;
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    });
              }, // end onSubmit
            ),
          ),
          CustomButton(
              onPressed: () async {
                // try {
                //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
                //       verificationId: verificationId!, smsCode: smsCode);

                //   // Sign the user in (or link) with the credential
                //   await auth.signInWithCredential(credential);
                //   Helper.displaySnackBar(context, "Success");
                //   Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChangePassword(),
                //       ),
                //       (route) => false);
                // } catch (e) {
                //   Helper.displaySnackBar(context, "Invalid OTP code");
                // }
              },
              child: Text("Proceed"))
        ],
      )),
    );
  }
}
