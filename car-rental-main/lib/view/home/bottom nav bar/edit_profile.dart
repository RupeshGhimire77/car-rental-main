import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_application_1/view/home/user%20login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final QueryDocumentSnapshot userData;
  const EditProfile({super.key, required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<UserProvider>(context, listen: false);
    // Initialize controllers with existing values
    provider.nameController =
        TextEditingController(text: widget.userData['name']);
    provider.emailController =
        TextEditingController(text: widget.userData['email']);
    provider.mobileNumberController =
        TextEditingController(text: widget.userData['mobileNumber']);
    provider.passwordController =
        TextEditingController(text: widget.userData['password']);
    provider.confirmPasswordController =
        TextEditingController(text: widget.userData['confirmPassword']);
  }

  @override
  void dispose() {
    var provider = Provider.of<UserProvider>(context, listen: false);
    provider.nameController.dispose();
    provider.emailController.dispose();
    provider.mobileNumberController.dispose();
    provider.passwordController.dispose();
    provider.confirmPasswordController.dispose();
    super.dispose();
  }

  File file = File("");
  String? downloadUrl;

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    String email = widget.userData['email'];
    String id = widget.userData['id'];

    print("User ID:" + id);
    // String name = widget.userData['name'];
    // String mobileNumber = widget.userData['mobileNumber'] ?? "";
    // String role = widget.userData['role'];

    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final userDetails = userProvider.getUserByEmail(email);

      return Scaffold(
        backgroundColor: Color(0xff771616),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
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
                  GestureDetector(
                    onTap: () async {
                      // Helper.displaySnackBar(context, "Clicked on the image");
                      await pickImage();
                    },
                    child: Stack(children: [
                      downloadUrl != null && downloadUrl!.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey,
                              ),
                              height:
                                  MediaQuery.of(context).size.height * 0.175,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/background_person.png'),
                                  image: NetworkImage(downloadUrl!),
                                  height: MediaQuery.of(context).size.height *
                                      0.175,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.175,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Image Error',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : userDetails?.image != null &&
                                  userDetails!.image!.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey,
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.175,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          'assets/images/background_person.png'),
                                      image: NetworkImage(userDetails.image!),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.175,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.175,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Image Error',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey,
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.175,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  alignment: Alignment.center,
                                  child: Text('No Image',
                                      style: TextStyle(color: Colors.white)),
                                ),
                      if (downloadUrl != null)
                        Visibility(
                          visible: false,
                          child: CustomTextFormField(
                            controller: userProvider.setImage(downloadUrl!),
                            labelText: "Car Image",
                          ),
                        ),
                      Positioned(
                          bottom: 10,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red[200]),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ))
                    ]),
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: userProvider.setRole("user"),
                    ),
                  ),
                  CustomTextFormField(
                    controller: userProvider.nameController,
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
                  GestureDetector(
                    onTap: () => Helper.displaySnackBar(
                        context, "You cannot change your email."),
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: userProvider.emailController,
                        readOnly: true,
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
                    ),
                  ),
                  CustomTextFormField(
                    controller: userProvider.passwordController,
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
                          userProvider.showPassword =
                              !userProvider.showPassword;
                        });
                      },
                      icon: userProvider.showPassword
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  CustomTextFormField(
                    controller: userProvider.confirmPasswordController,
                    onChanged: (p0) => userProvider.setConfirmPassword(p0),
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return confirmPasswordValidationStr;
                      } else if (p0 != userProvider.passwordController.text) {
                        // Compare with the controller's text
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
                  GestureDetector(
                    onTap: () => Helper.displaySnackBar(
                        context, "You Cannot change your Mobile Number."),
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: userProvider.mobileNumberController,
                        readOnly: true,
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
                    ),
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        User1 user = User1(
                          name: userProvider.nameController.text,
                          email: userProvider.emailController.text,
                          password: userProvider.passwordController.text,
                          confirmPassword:
                              userProvider.confirmPasswordController.text,
                          mobileNumber:
                              userProvider.mobileNumberController.text,
                        );

                        await userProvider.updateUserData(user, id);
                        if (userProvider.getUserDataUpdateStatus ==
                            StatusUtil.success) {
                          Helper.displaySnackBar(
                              context, "Details Changed Successfully!");
                          Navigator.pop(context);
                        } else if (userProvider.getUserDataUpdateStatus ==
                            StatusUtil.error) {
                          Helper.displaySnackBar(
                              context, "Failed to update details.");
                        }
                      }
                    },
                    child: userProvider.isUserDataUpdated
                        ? CircularProgressIndicator()
                        : Text("Save Changes",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  CustomButton(
                      onPressed: () async {
                        await deleteUserShowDialog(context, userProvider, id);
                      },
                      child: userProvider.isUserDelete
                          ? CircularProgressIndicator()
                          : Text("Delete Account",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  deleteUserShowDialog(
      BuildContext context, UserProvider userProvider, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your Account?'),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await userProvider.deleteUser(id);
                  if (userProvider.getUserDeleteStatus == StatusUtil.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Account deleted successfully!")),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to delete account.")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An error occurred: $e")),
                  );
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  pickImage() async {
    setState(() {
      // loader = true; // Set loader to true before upload
    });

    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User might have canceled

    file = File(image.path);
    setState(() {
      file; // Update file state for preview
    });

    try {
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref().child('userImage');
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();

      setState(() {
        downloadUrl; // Update downloadUrl for the form field
        loader = false; // Hide loader after successful upload
      });
    } catch (e) {
      setState(() {
        loader = false; // Hide loader even on error
      });
      // Print error for debugging
    }
  }
}
