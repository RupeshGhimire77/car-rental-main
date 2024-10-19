import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/book_car.dart';
import 'package:flutter_application_1/service/book_car_service.dart';
import 'package:flutter_application_1/service/book_car_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class BookCarProvider extends ChangeNotifier {
  String? bookCarId;

  TextEditingController pickUpPointController = TextEditingController();
  TextEditingController destinationPointController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController pickUpTimeController = TextEditingController();
  TextEditingController dropTimeController = TextEditingController();
  TextEditingController bookCarImageController = TextEditingController();

  String? errorMessage;

  TextEditingController? bookCarImage;
  bool isSuccess = false;

  List<BookCar> bookList = [];

  BookCarService bookCarService = BookCarServiceImpl();

  StatusUtil _saveBookCarStatus = StatusUtil.none;
  StatusUtil get saveBookCarStatus => _saveBookCarStatus;

  StatusUtil _getBookCarStatus = StatusUtil.none;
  StatusUtil get getBookCarStatus => _getBookCarStatus;

  void setPickUpPoint(String value) {
    pickUpPointController.text = value;
    notifyListeners();
  }

  void setDestinationPoint(String value) {
    destinationPointController.text = value;
    notifyListeners();
  }

  void setStartDate(String value) {
    startDateController.text = value;
    notifyListeners();
  }

  void setEndDate(String value) {
    endDateController.text = value;
    notifyListeners();
  }

  void setPickUpTime(String value) {
    pickUpTimeController.text = value;
    notifyListeners();
  }

  void setDropTime(String value) {
    dropTimeController.text = value;
    notifyListeners();
  }

  // void setBookCarImage(String value) {
  //   bookCarImageController.text = value;
  //   notifyListeners();
  // }

  setBookCarImage(value) {
    bookCarImage = TextEditingController(text: value);
  }

  setSaveBookCarStatus(StatusUtil status) {
    _saveBookCarStatus = status;
    notifyListeners();
  }

  setGetBookCarStatus(StatusUtil status) {
    _getBookCarStatus = status;
    notifyListeners();
  }

  Future<void> saveBookCar() async {
    if (_saveBookCarStatus != StatusUtil.loading) {
      setSaveBookCarStatus(StatusUtil.loading);
    }

    BookCar bookCar = BookCar(
        bookCarId: bookCarId,
        pickUpPoint: pickUpPointController.text,
        destinationPoint: destinationPointController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        pickUpTime: pickUpTimeController.text,
        dropTime: dropTimeController.text,
        bookCarImage: bookCarImage!.text);

    ApiResponse response = await bookCarService.saveBookCar(bookCar);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = true;
      setSaveBookCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setSaveBookCarStatus(StatusUtil.error);
    }
  }

  Future<void> getBookCar() async {
    if (_getBookCarStatus != StatusUtil.loading) {
      setGetBookCarStatus(StatusUtil.loading);
    }

    ApiResponse response = await bookCarService.getBookCar();

    if (response.statusUtil == StatusUtil.success) {
      bookList = response.data;
      setGetBookCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetBookCarStatus(StatusUtil.error);
    }
  }
}
