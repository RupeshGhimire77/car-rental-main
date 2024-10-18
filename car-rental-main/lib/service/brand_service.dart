import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/brand.dart';

abstract class BrandService {
  Future<ApiResponse> saveBrand(Brand brand);
  Future<ApiResponse> getBrand();
  Future<ApiResponse> deleteBrand(String id);
}
