import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/brand.dart';
import 'package:flutter_application_1/service/brand_service.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';

class BrandServiceImpl implements BrandService {
  @override
  Future<ApiResponse> saveBrand(Brand brand) async {
    bool isSuccess = false;
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("carBrand")
            .add(brand.toJson())
            .then(
          (value) {
            isSuccess = true;
          },
        );
        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  @override
  Future<ApiResponse> getBrand() async {
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        var value =
            await FirebaseFirestore.instance.collection("carBrand").get();
        var brandList =
            value.docs.map((e) => Brand.fromJson(e.data())).toList();
        for (int i = 0; i < brandList.length; i++) {
          brandList[i].brandId = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: brandList);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.success, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }

  @override
  Future<ApiResponse> deleteBrand(String id) async {
    bool isSuccess = false;
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("carBrand")
            .doc(id)
            .delete()
            .then(
          (value) {
            isSuccess = true;
          },
        );

        return ApiResponse(statusUtil: StatusUtil.success, data: isSuccess);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: e.toString());
      }
    }
    return ApiResponse(
        statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
  }
}
