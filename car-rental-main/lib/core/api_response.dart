import 'package:flutter_application_1/utils/status_util.dart';

class ApiResponse {
  StatusUtil? statusUtil;
  dynamic data;
  String? errorMessage;
  ApiResponse({this.statusUtil, this.data, this.errorMessage});
}
