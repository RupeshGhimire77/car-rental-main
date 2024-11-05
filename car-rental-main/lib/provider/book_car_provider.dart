import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/book_car.dart';
import 'package:flutter_application_1/service/book_car_service.dart';
import 'package:flutter_application_1/service/book_car_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class BookCarProvider extends ChangeNotifier {
  String? bookCarId;
  String? carId;

  bool? isCancelled;

  TextEditingController pickUpPointController = TextEditingController();
  // TextEditingController? destinationPointController;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController pickUpTimeController = TextEditingController();
  TextEditingController dropTimeController = TextEditingController();
  TextEditingController bookCarImageController = TextEditingController();

  TextEditingController? carIdTextField;
  TextEditingController? emailTextField;

  String? errorMessage;

  TextEditingController? bookCarImage;

  bool isSuccess = false;
  bool isDeleteBooking = false;

  List<BookCar> bookList = [];

  BookCarService bookCarService = BookCarServiceImpl();

  StatusUtil _saveBookCarStatus = StatusUtil.none;
  StatusUtil get saveBookCarStatus => _saveBookCarStatus;

  StatusUtil _getBookCarStatus = StatusUtil.none;
  StatusUtil get getBookCarStatus => _getBookCarStatus;

  StatusUtil _deleteCarBookingStatus = StatusUtil.none;
  StatusUtil get deleteCarBookingStatus => _deleteCarBookingStatus;

  StatusUtil _updateBookingStatus = StatusUtil.none;
  StatusUtil get updateBookingStatus => _updateBookingStatus;

  // setEmail(value) {
  //   emailTextField = TextEditingController(text: value);
  // }

  // setCarId(value) {
  //   carIdTextField = TextEditingController(text: value);
  // }

  setEmail(String value) {
    emailTextField?.text = value;
  }

  setCarId(String value) {
    carIdTextField?.text = value;
  }

  void setPickUpPoint(String value) {
    pickUpPointController.text = value;
    notifyListeners();
  }

  // setDestinationPoint(value) {
  //   // destinationPointController.text = value;
  //   destinationPointController = TextEditingController(text: value);
  //   // destinationPoint = value;
  //   notifyListeners();
  // }

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

  setGetDeleteCarBookingStatus(StatusUtil status) {
    _deleteCarBookingStatus = status;
    notifyListeners();
  }

  setUpdateBookingStatus(StatusUtil status) {
    _updateBookingStatus = status;
    notifyListeners();
  }

  Future<void> saveBookCar() async {
    if (_saveBookCarStatus != StatusUtil.loading) {
      setSaveBookCarStatus(StatusUtil.loading);
    }

    BookCar bookCar = BookCar(
        bookCarId: bookCarId,
        pickUpPoint: pickUpPointController.text,
        // destinationPoint: destinationPointController!.text,
        // destinationPoint: destinationPoint,
        startDate: startDateController.text,
        endDate: endDateController.text,
        pickUpTime: pickUpTimeController.text,
        dropTime: dropTimeController.text,
        bookCarImage: bookCarImage!.text,
        carId: carIdTextField?.text,
        email: emailTextField?.text,
        isCancelled: false);

    ApiResponse response = await bookCarService.saveBookCar(bookCar);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = response.data;
      setSaveBookCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setSaveBookCarStatus(StatusUtil.error);
    }
  }

  Future<void> updateBookCar() async {
    if (_updateBookingStatus != StatusUtil.loading) {
      setUpdateBookingStatus(StatusUtil.loading);
    }

    BookCar bookCar = BookCar(
        bookCarId: bookCarId,
        pickUpPoint: pickUpPointController.text,
        // destinationPoint: destinationPointController!.text,
        // destinationPoint: destinationPoint,
        startDate: startDateController.text,
        endDate: endDateController.text,
        pickUpTime: pickUpTimeController.text,
        dropTime: dropTimeController.text,
        bookCarImage: bookCarImage!.text,
        carId: carIdTextField?.text,
        email: emailTextField?.text,
        isCancelled: false);

    ApiResponse response = await bookCarService.updateBookingData(bookCar);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = response.data;
      setUpdateBookingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setUpdateBookingStatus(StatusUtil.error);
    }
  }

  List<BookCar> getUserBookings(String email) {
    return bookList.where((booking) => booking.email == email).toList();
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

    // print("API response data: ${response.data}");
    bookList =
        response.data ?? []; // Ensures bookList is at least an empty list
  }

  Future<void> deleteCarBooking(String brandId) async {
    if (_deleteCarBookingStatus != StatusUtil.loading) {
      setGetDeleteCarBookingStatus(StatusUtil.loading);
    }

    ApiResponse response = await bookCarService.cancelBooking(brandId);
    if (response.statusUtil == StatusUtil.success) {
      isDeleteBooking = response.data;
      setGetDeleteCarBookingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setGetDeleteCarBookingStatus(StatusUtil.error);
    }
  }
}
