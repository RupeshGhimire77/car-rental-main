import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/rating.dart';
import 'package:flutter_application_1/service/rating_service.dart';
import 'package:flutter_application_1/service/rating_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class RatingProvider extends ChangeNotifier {
  String? carId, email;
  String? errorMessage;

  RatingService ratingService = RatingServiceImpl();

  TextEditingController ratingController = TextEditingController();

  StatusUtil _saveRatingStatus = StatusUtil.none;
  StatusUtil get saveRatingStatus => _saveRatingStatus;

  bool isSuccess = false;

  setCarId(value) {
    carId = value;
  }

  setEmail(value) {
    email = value;
  }

  void setRating(String value) {
    ratingController.text = value;
    notifyListeners();
  }

  setSaveRatingStatus(StatusUtil status) {
    _saveRatingStatus = status;
    notifyListeners();
  }

  Future<void> saveRating({String? id, String? email}) async {
    if (_saveRatingStatus != StatusUtil.loading) {
      setSaveRatingStatus(StatusUtil.loading);
    }

    Rating rateCar = Rating(
      rating: ratingController.text,
      carId: id,
      email: email,
    );

    ApiResponse response = await ratingService.saveRating(rateCar);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = response.data;
      setSaveRatingStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setSaveRatingStatus(StatusUtil.error);
    }
  }
}
