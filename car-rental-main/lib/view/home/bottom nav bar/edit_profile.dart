import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  User1? user;
  EditProfile({super.key, this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  // @override
  // void initState() {
  //   // if (widget.user != null) {
  //   //   var provider = Provider.of<UserProvider>(context, listen: false);
  //   //   provider.id = widget.user!.id ?? "";
  //   //   provider.name = widget.user!.name ?? "";
  //   //   provider.email = widget.user!.email ?? "";
  //   //   provider.mobileNumber = widget.user!.mobileNumber ?? "";
  //   // }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        backgroundColor: Color(0xff771616),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/images/Jackie-Chan.jpeg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: CustomTextFormField(
                    // initialValue: userProvider.name,
                    onChanged: (p0) => userProvider.setEmail(p0),
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return nameValidationStr;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    prefixIcon: Icon(Icons.person),
                    hintText: nameStr,
                    fillColor: Colors.white,
                  ),
                ),
                CustomTextFormField(
                  // initialValue: userProvider.email,
                  onChanged: (p0) => userProvider.setEmail(p0),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return emailValidationStr;
                    }
                    RegExp regExp = RegExp(emailRegexPatternStr);
                    if (!regExp.hasMatch(p0)) {
                      return validEmailAddrStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email),
                  hintText: emailStr,
                  fillColor: Colors.white,
                ),
                CustomTextFormField(
                  // initialValue: userProvider.mobileNumber,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return mobileNumberValidationStr;
                    } else if (p0.length != 10) {
                      return mobileNumberLengthValidationStr;
                    }

                    RegExp regex = RegExp(mobileNumberRegexPattern);
                    if (!regex.hasMatch(p0)) {
                      return validMobileNumberStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  onChanged: (p0) => userProvider.setMobileNumber(p0),
                  prefixIcon: Icon(Icons.install_mobile_outlined),
                  hintText: mobileNumberStr,
                  fillColor: Colors.white,
                ),
                CustomButton(
                  onPressed: () {},
                  child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  // onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  //   await userProvider.loginUser();
                  //   if (userProvider.getLoginUserStatus ==
                  //       StatusUtil.success) {
                  //     if (userProvider.isUserExist) {
                  //       await Helper.displaySnackBar(
                  //           context, loginSuccessStr);
                  //       await userProvider.storeValueToSharedPreference();
                  //       Navigator.pushAndRemoveUntil(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => BottomNavBar(),
                  //           ),
                  //           (route) => false);
                  //     } else {
                  //       await Helper.displaySnackBar(
                  //           context, userDoesntExiststr);
                  //     }
                  //   } else {
                  //     Helper.displaySnackBar(
                  //         context, invalidCredentialsStr);
                  //   }
                  // } else if (userProvider.getLoginUserStatus ==
                  //     StatusUtil.error) {
                  //   Helper.displaySnackBar(context, loginFailedStr);
                  // }
                  // },
                  // child:
                  // userProvider.getLoginUserStatus == StatusUtil.loading
                  // ? CircularProgressIndicator()
                  // : Text(
                  //     signInStr,
                  //     style: TextStyle(color: Colors.white, fontSize: 20),
                  //   )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
