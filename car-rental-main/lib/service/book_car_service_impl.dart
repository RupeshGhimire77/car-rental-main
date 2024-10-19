import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/book_car.dart';
import 'package:flutter_application_1/service/book_car_service.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';

class BookCarServiceImpl implements BookCarService {
  @override
  Future<ApiResponse> saveBookCar(BookCar bookCar) async {
    bool isSuccess = false;
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        await FirebaseFirestore.instance
            .collection("bookCar")
            .add(bookCar.toJson())
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
  Future<ApiResponse> getBookCar() async {
    if (await Helper.isInternetConnectionAvailable()) {
      try {
        var value =
            await FirebaseFirestore.instance.collection("carBrand").get();
        var bookCarList =
            value.docs.map((e) => BookCar.fromJson(e.data())).toList();
        for (int i = 0; i < bookCarList.length; i++) {
          bookCarList[i].bookCarId = value.docs[i].id;
        }
        return ApiResponse(statusUtil: StatusUtil.success, data: bookCarList);
      } catch (e) {
        return ApiResponse(
            statusUtil: StatusUtil.success, errorMessage: e.toString());
      }
    } else {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: noInternetConnectionStr);
    }
  }
}
