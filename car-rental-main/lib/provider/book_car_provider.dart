import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool? isCancelledByAdmin;

  bool? isApproved;

  bool? isPaid;

  TextEditingController pickUpPointController = TextEditingController();
  // TextEditingController? destinationPointController;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController pickUpTimeController = TextEditingController();
  TextEditingController dropTimeController = TextEditingController();
  TextEditingController bookCarImageController = TextEditingController();

  String? errorMessage;

  TextEditingController? bookCarImage;

  bool isSuccess = false;
  bool isCancelBooking = false;
  bool isCancelByAdminBooking = false;
  bool isApproveBooking = false;
  bool isPaidBooking = false;

  List<BookCar> bookList = [];

  final List<Map<String, List<String>>> places = [
    {
      'Dhulikhel': [
        'Dhulikhel Bus Park',
        'Bhaktapur Durbar Square',
        'Dhulikhel Hospital',
        'Kali Temple',
        'Buddha Stupa',
      ]
    },
    {
      'Panauti': [
        'Panauti Bus Park',
        'Panauti Museum',
        'Indreshwor Mahadev Temple',
        'Brahmayani Temple',
        'Panauti Heritage Area',
      ]
    },
    {
      'Banepa': [
        'Banepa Bus Park',
        'Bhimsen Temple',
        'Banepa Durbar Square',
        'Kankrej Bhanjyang',
        'Khadgakot',
      ]
    },
    {
      'Kalaiya': [
        'Kalaiya Market',
        'Kalaiya Bus Park',
      ]
    },
    {
      'Nala': [
        'Nala Bus Park',
        'Nala Temple',
      ]
    },
    {
      'Namobuddha': [
        'Namobuddha Monastery',
        'Namobuddha Stupa',
      ]
    },
    {
      'Sankhu': [
        'Sankhu Bus Park',
        'Sankhu Durbar Square',
        'Bajrayogini Temple',
      ]
    },
    {
      'Kavre': [
        'Kavre Bus Park',
        'Various local markets',
      ]
    },
    {
      'Bhakundebesi': [
        'Bhakundebesi Market',
        'Local temples and shrines',
      ]
    },
  ];

  // Flatten the list to get all place names
  List<String> getAllPlaces() {
    List<String> allPlaces = [];
    for (var place in places) {
      place.forEach((key, value) {
        allPlaces.addAll(value); // Add all locations from each place
      });
    }
    return allPlaces;
  }

  BookCarService bookCarService = BookCarServiceImpl();

  StatusUtil _saveBookCarStatus = StatusUtil.none;
  StatusUtil get saveBookCarStatus => _saveBookCarStatus;

  StatusUtil _getBookCarStatus = StatusUtil.none;
  StatusUtil get getBookCarStatus => _getBookCarStatus;

  StatusUtil _cancelCarBookingStatus = StatusUtil.none;
  StatusUtil get cancelCarBookingStatus => _cancelCarBookingStatus;

  StatusUtil _cancelCarBookingByAdminStatus = StatusUtil.none;
  StatusUtil get cancelCarBookingByAdminStatus =>
      _cancelCarBookingByAdminStatus;

  StatusUtil _approveCarBookingStatus = StatusUtil.none;
  StatusUtil get approveCarBookingStatus => _approveCarBookingStatus;

  StatusUtil _isPaidBookingStatus = StatusUtil.none;
  StatusUtil get isPaidBookingStatus => _isPaidBookingStatus;

  StatusUtil _updateBookingStatus = StatusUtil.none;
  StatusUtil get updateBookingStatus => _updateBookingStatus;

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

  setCancelCarBookingStatus(StatusUtil status) {
    _cancelCarBookingStatus = status;
    notifyListeners();
  }

  setCancelCarBookingByAdminStatus(StatusUtil status) {
    _cancelCarBookingByAdminStatus = status;
    notifyListeners();
  }

  setApproveCarBookingStatus(StatusUtil status) {
    _approveCarBookingStatus = status;
    notifyListeners();
  }

  setIsPaidBookingStatus(StatusUtil status) {
    _isPaidBookingStatus = status;
    notifyListeners();
  }

  setUpdateBookingStatus(StatusUtil status) {
    _updateBookingStatus = status;
    notifyListeners();
  }

  Future<void> saveBookCar({String? id, String? email}) async {
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
        bookCarImage: bookCarImage?.text ?? "",
        carId: id,
        email: email,
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

  Future<void> updateBookCar({String? email, String? carId}) async {
    try {
      // print("Entering updateBookCar function");

      if (_updateBookingStatus != StatusUtil.loading) {
        setUpdateBookingStatus(StatusUtil.loading);
        // print("Status set to loading");
      }

      BookCar bookCar = BookCar(
        bookCarId: bookCarId,
        pickUpPoint: pickUpPointController.text,
        startDate: startDateController.text,
        endDate: endDateController.text,
        pickUpTime: pickUpTimeController.text,
        dropTime: dropTimeController.text,
        bookCarImage: bookCarImage?.text ?? "",
        carId: carId,
        email: email,
        isCancelled: false,
      );

      print("BookCar object created: ${bookCar.toJson()}");

      ApiResponse response = await bookCarService.updateBookingData(bookCar);
      if (response.statusUtil == StatusUtil.success) {
        isSuccess = response.data;
        setUpdateBookingStatus(StatusUtil.success);
      } else {
        errorMessage = response.errorMessage;
        setUpdateBookingStatus(StatusUtil.error);
      }
    } catch (e) {
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

  Future<void> cancelCarBooking(String bookId) async {
    if (_cancelCarBookingStatus != StatusUtil.loading) {
      setCancelCarBookingStatus(StatusUtil.loading);
    }
    BookCar bookCar = BookCar(isCancelled: true);
    ApiResponse response = await bookCarService.cancelBooking(bookId, bookCar);
    if (response.statusUtil == StatusUtil.success) {
      isCancelBooking = response.data;
      getBookCar();
      setCancelCarBookingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setCancelCarBookingStatus(StatusUtil.error);
    }
  }

  Future<void> cancelCarBookingByAdmin(String bookId) async {
    if (_cancelCarBookingByAdminStatus != StatusUtil.loading) {
      setCancelCarBookingByAdminStatus(StatusUtil.loading);
    }
    BookCar bookCar = BookCar(isCancelledByAdmin: true);
    ApiResponse response =
        await bookCarService.cancelBookingByAdmin(bookId, bookCar);
    if (response.statusUtil == StatusUtil.success) {
      isCancelByAdminBooking = response.data;
      getBookCar();
      setCancelCarBookingByAdminStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setCancelCarBookingByAdminStatus(StatusUtil.error);
    }
  }

  Future<void> approveCarBooking(String bookId) async {
    if (_approveCarBookingStatus != StatusUtil.loading) {
      setApproveCarBookingStatus(StatusUtil.loading);
    }
    BookCar bookCar = BookCar(isApproved: true);
    ApiResponse response = await bookCarService.approveBooking(bookId, bookCar);
    if (response.statusUtil == StatusUtil.success) {
      isApproveBooking = response.data;
      getBookCar();
      setApproveCarBookingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setApproveCarBookingStatus(StatusUtil.error);
    }
  }

  Future<void> isPaidCarBooking(String bookId) async {
    if (_isPaidBookingStatus != StatusUtil.loading) {
      setIsPaidBookingStatus(StatusUtil.loading);
    }
    BookCar bookCar = BookCar(isPaid: true);
    ApiResponse response = await bookCarService.isPaidBooking(bookId, bookCar);
    if (response.statusUtil == StatusUtil.success) {
      isPaidBooking = response.data;
      getBookCar();
      setIsPaidBookingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setIsPaidBookingStatus(StatusUtil.error);
    }
  }

  Future<List<QueryDocumentSnapshot>> getPaidBookings(
      String? email, String? carId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("bookCar")
        .where("carId", isEqualTo: carId)
        .where("email", isEqualTo: email)
        .where("isPaid", isEqualTo: true)
        .get();

    return snapshot.docs;
  }
}
