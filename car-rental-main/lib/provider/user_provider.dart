import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/service/user_service.dart';
import 'package:flutter_application_1/service/user_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? id;
  String? name, email, password, confirmPassword, mobileNumber;
  String? errorMessage;

  bool isSuccess = false;
  // String? role;

  bool isUserDelete = false;
  bool isUserDataUpdated = false;

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isUserExist = false;
  bool isEmailExist = false;
  bool isMobileNumberExist = false;
  bool checkRemeberMe = false;
  bool isSignedInGoogle = false;

  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController? roleTextField;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  TextEditingController? imageController = TextEditingController();

  setImage(value) {
    imageController = TextEditingController(text: value);
  }

  setRole(value) {
    roleTextField = TextEditingController(text: value);
  }

  isCheckedStatus(value) {
    checkRemeberMe = value!;
    notifyListeners();
  }

  // setId(value) {
  //   id = value;
  //   notifyListeners();
  // }

  setName(value) {
    name = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setPassword(value) {
    password = value;
    notifyListeners();
  }

  setConfirmPassword(value) {
    confirmPassword = value;
    notifyListeners();
  }

  setMobileNumber(value) {
    mobileNumber = value;
    notifyListeners();
  }

  List<User1> userList = [];
  UserService userService = UserServiceImpl();

  StatusUtil _saveUserStatus = StatusUtil.none;
  StatusUtil get saveUserStatus => _saveUserStatus;

  StatusUtil _getUserStatus = StatusUtil.none;
  StatusUtil get getUserStatus => _getUserStatus;

  StatusUtil _getLoginUserStatus = StatusUtil.none;
  StatusUtil get getLoginUserStatus => _getLoginUserStatus;

  StatusUtil _getCheckEmailExistInSignUp = StatusUtil.none;
  StatusUtil get getCheckEmailExistInSignUp => _getCheckEmailExistInSignUp;

  StatusUtil _getCheckMobileNumberOnSignUp = StatusUtil.none;
  StatusUtil get getCheckMobileNumberOnSignup => _getCheckMobileNumberOnSignUp;

  StatusUtil _getUserDeleteStatus = StatusUtil.none;
  StatusUtil get getUserDeleteStatus => _getUserDeleteStatus;

  StatusUtil _getUserDataUpdateStatus = StatusUtil.none;
  StatusUtil get getUserDataUpdateStatus => _getUserDataUpdateStatus;

  setGetUserDataUpdateUserStatus(StatusUtil status) {
    _getUserDataUpdateStatus = status;
    notifyListeners();
  }

  setGetUserDeleteStatus(StatusUtil status) {
    _getUserDeleteStatus = status;
    notifyListeners();
  }

  setGetCheckMobileNumberOnSignUp(StatusUtil status) {
    _getCheckEmailExistInSignUp = status;
    notifyListeners();
  }

  setGetCheckEmailExistInSignUP(StatusUtil status) {
    _getCheckEmailExistInSignUp = status;
    notifyListeners();
  }

  setSaveUserStatus(StatusUtil status) {
    _saveUserStatus = status;
    notifyListeners();
  }

  setGetUserStatus(StatusUtil status) {
    _getUserStatus = status;
    notifyListeners();
  }

  setGetLoginUserStatus(StatusUtil status) {
    _getLoginUserStatus = status;
    notifyListeners();
  }

  Future<void> saveUser() async {
    if (_saveUserStatus != StatusUtil.loading) {
      setSaveUserStatus(StatusUtil.loading);
    }

    User1 user = User1(
        id: id,
        role: roleTextField?.text,
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        mobileNumber: mobileNumber);

    ApiResponse response = await userService.saveUser(user);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = response.data;
      setSaveUserStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setSaveUserStatus(StatusUtil.error);
    }
  }

  Future<void> getUser() async {
    if (_getUserStatus != StatusUtil.loading) {
      setGetUserStatus(StatusUtil.loading);

      ApiResponse response = await userService.getUser();
      if (response.statusUtil == StatusUtil.success) {
        userList = response.data;
        setGetUserStatus(StatusUtil.success);
      } else if (response.statusUtil == StatusUtil.error) {
        errorMessage = response.errorMessage;
        setGetUserStatus(StatusUtil.error);
      }
    }
  }

  User1? getUserByEmail(String? email) {
    try {
      return userList.firstWhere((car) => car.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<void> checkEmailonSignUp() async {
    if (_getCheckEmailExistInSignUp != StatusUtil.loading) {
      setGetCheckEmailExistInSignUP(StatusUtil.loading);
    }
    User1 user = User1(email: email);
    ApiResponse response = await userService.doesEmailExistOnSignUp(user);

    if (response.statusUtil == StatusUtil.success) {
      isEmailExist = response.data;
      setGetCheckEmailExistInSignUP(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCheckEmailExistInSignUP(StatusUtil.error);
    }
  }

  Future<void> checkMobileNumberOnSignUp() async {
    if (_getCheckMobileNumberOnSignUp != StatusUtil.loading) {
      setGetCheckMobileNumberOnSignUp(StatusUtil.loading);
    }

    User1 user = User1(mobileNumber: mobileNumber);
    ApiResponse response =
        await userService.doesMobileNumberExistOnSignUp(user);

    if (response.statusUtil == StatusUtil.success) {
      isMobileNumberExist = response.data;
      setGetCheckMobileNumberOnSignUp(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCheckMobileNumberOnSignUp(StatusUtil.error);
    }
  }

  Future<void> loginUser() async {
    if (getLoginUserStatus != StatusUtil.loading) {
      setGetLoginUserStatus(StatusUtil.loading);
    }

    // Clear previous user data
    UserData.userData = null; // Clear previous user data
    isUserExist = false; // Reset user existence status

    User1 user = User1(
      email: emailTextField.text,
      password: passwordTextField.text,
    );

    ApiResponse response = await userService.checkUserData(user);

    if (response.statusUtil == StatusUtil.success) {
      User1? userData = response.data;
      if (userData != null) {
        UserData.userData = userData;
        isUserExist = true;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("name", userData.name.toString());
        prefs.setString("email", userData.email.toString());
        prefs.setString("role", userData.role.toString());
      }

      setGetLoginUserStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetLoginUserStatus(StatusUtil.error);
    }
  }

  storeValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  rememberMe(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString("email", emailTextField.text);
      await prefs.setString("password", passwordTextField.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  readRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emailTextField.text = await prefs.getString('email') ?? "";
    passwordTextField.text = await prefs.getString('password') ?? "";
    notifyListeners();
  }

  Future<List<QueryDocumentSnapshot>> getUsersWithEmail(
    String? email,
  ) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("user")
        .where("email", isEqualTo: email)
        .get();

    return snapshot.docs;
  }

  Future<void> deleteUser(String id) async {
    if (_getUserDeleteStatus != StatusUtil.loading) {
      setGetUserDeleteStatus(StatusUtil.loading);
    }

    ApiResponse response = await userService.deleteUser(id);
    if (response.statusUtil == StatusUtil.success) {
      isUserDelete = response.data;
      setGetUserDeleteStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setGetUserDeleteStatus(StatusUtil.error);
    }
  }

  Future<void> updateUserData(User1 user, String? id) async {
    try {
      if (_getUserDataUpdateStatus != StatusUtil.loading) {
        setGetUserDataUpdateUserStatus(StatusUtil.loading);
      }

      User1 user = User1(
        id: id,
        role: roleTextField?.text,
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        mobileNumber: mobileNumberController.text,
        image: imageController?.text ?? "",
      );

      ApiResponse response = await userService.updateUserData(user);
      if (response.statusUtil == StatusUtil.success) {
        isSuccess = response.data;
        setGetUserDataUpdateUserStatus(StatusUtil.success);
      } else {
        errorMessage = response.errorMessage;
        setGetUserDataUpdateUserStatus(StatusUtil.error);
      }
    } catch (e) {
      setGetUserDataUpdateUserStatus(StatusUtil.error);
    }
  }
}

class UserData {
  static User1? userData;
}
