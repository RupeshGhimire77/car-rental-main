import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/book_car.dart';

abstract class BookCarService {
  Future<ApiResponse> saveBookCar(BookCar bookCar);
  Future<ApiResponse> getBookCar();
  Future<ApiResponse> cancelBooking(String bookId, BookCar bookCar);
  Future<ApiResponse> cancelBookingByAdmin(String bookId, BookCar bookCar);
  Future<ApiResponse> approveBooking(String bookId, BookCar bookCar);
  Future<ApiResponse> isPaidBooking(String bookId, BookCar bookCar);

  Future<ApiResponse> updateBookingData(BookCar bookCar);
}
