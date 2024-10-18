import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/user.dart';

abstract class UserService {
  Future<ApiResponse> saveUser(User1 user);
  Future<ApiResponse> getUser();
  // Future<ApiResponse> getIndividualUser(User user);
  Future<ApiResponse> checkUserData(User1 user);
  Future<ApiResponse> doesEmailExistOnSignUp(User1 user);
  Future<ApiResponse> doesMobileNumberExistOnSignUp(User1 user);
}
