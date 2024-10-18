import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_application_1/view/home/user%20login/login.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF771616),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) => SafeArea(
            child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Center(
                    child: Text(
                      letsCreateAccountStr,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: TextFormField(
                    controller: userProvider.setRole("user"),
                  ),
                ),
                CustomTextFormField(
                  onChanged: (value) => userProvider.setName(value),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return nameValidationStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white,
                  hintText: nameStr,
                ),
                CustomTextFormField(
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return emailValidationStr;
                    }

                    RegExp regex = RegExp(emailRegexPatternStr);
                    if (!regex.hasMatch(p0)) {
                      return validEmailAddrStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (p0) => userProvider.setEmail(p0),
                  prefixIcon: Icon(Icons.email),
                  hintText: emailStr,
                  fillColor: Colors.white,
                ),
                CustomTextFormField(
                  onChanged: (p0) => userProvider.setPassword(p0),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return passwordValidationStr;
                    } else if (p0.length < 8) {
                      return passwordLengthValidationStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !userProvider.showPassword,
                  hintText: passwordStr,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        userProvider.showPassword = !userProvider.showPassword;
                      });
                    },
                    icon: userProvider.showPassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
                CustomTextFormField(
                  onChanged: (p0) => userProvider.setConfirmPassword(p0),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return confirmPasswordValidationStr;
                    } else if (p0 != userProvider.password) {
                      return confirmPasswordValidationStr;
                    }
                    return null;
                  },
                  obscureText: !userProvider.showConfirmPassword,
                  hintText: confirmPasswordStr,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        userProvider.showConfirmPassword =
                            !userProvider.showConfirmPassword;
                      });
                    },
                    icon: userProvider.showConfirmPassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
                CustomTextFormField(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        termsAndConditionsStr,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          termsAndConditionsStr1,
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //First ,check id the email address is already in use or not.
                      await userProvider.checkEmailonSignUp();
                      if (userProvider.isEmailExist) {
                        //email is already in use so notify the user
                        await Helper.displaySnackBar(
                            context, userAlreadyExistStr);
                      } else {
                        // email is not in use so now check if the mobile number is already on use.
                        await userProvider.checkMobileNumberOnSignUp();

                        if (userProvider.isMobileNumberExist) {
                          //mobile number is already in use so notify the user.
                          Helper.displaySnackBar(
                              context, userWithMobileNumberAlreadyExistStr);
                        } else {
                          //both email and mobile number are available, so proceed with user registration
                          await userProvider.saveUser();
                          if (userProvider.saveUserStatus ==
                                  StatusUtil.success &&
                              userProvider.isSuccess) {
                            //User registration was successfull.
                            await Helper.displaySnackBar(
                                context, dataSuccessfullySavedStr);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (route) => false);
                          } else if (userProvider.saveUserStatus ==
                              StatusUtil.error) {
                            await Helper.displaySnackBar(
                                context, failedToSaveStr);
                          }
                        }
                      }
                    }
                  },
                  child: userProvider.saveUserStatus == StatusUtil.loading
                      ? CircularProgressIndicator()
                      : Text(
                          signUpStr,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alreadyHaveAnAccountStr,
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        ),
                        child: Text(
                          signInStr,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
