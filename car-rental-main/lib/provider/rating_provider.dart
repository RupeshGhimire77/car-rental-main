import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/rating.dart';
import 'package:flutter_application_1/service/rating_service.dart';
import 'package:flutter_application_1/service/rating_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class RatingProvider extends ChangeNotifier {
  String? carId, email, ratingId;
  String? errorMessage;

  bool? isRated;

  RatingService ratingService = RatingServiceImpl();

  Map<String, List<double>> ratingList = {};
  Map<String, List<int>> totalNoOfRatings = {};

  TextEditingController ratingController = TextEditingController();

  StatusUtil _saveRatingStatus = StatusUtil.none;
  StatusUtil get saveRatingStatus => _saveRatingStatus;

  bool isSuccess = false;

  // bool? isCarRated = false;

  StatusUtil _isCarRatedStatus = StatusUtil.none;
  StatusUtil get isCarRatedStatus => _isCarRatedStatus;

  setSaveIsCarRatedStatus(StatusUtil status) {
    _isCarRatedStatus = status;
    notifyListeners();
  }

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

    // Check if this user has already rated this car
    try {
      QuerySnapshot existingRatingSnapshot = await FirebaseFirestore.instance
          .collection("rating")
          .where("carId", isEqualTo: id)
          .where("email", isEqualTo: email)
          .get();

      if (existingRatingSnapshot.docs.isNotEmpty) {
        // If a rating already exists, prevent re-rating and show a message
        setSaveRatingStatus(StatusUtil.success);
        errorMessage = "You have already rated this car.";
        notifyListeners();
        return;
      }

      // If no previous rating, save the new rating
      Rating rateCar = Rating(
        ratingId: ratingId,
        rating: ratingController.text,
        carId: id,
        email: email,
      );

      ApiResponse response = await ratingService.saveRating(rateCar);

      if (response.statusUtil == StatusUtil.success) {
        isSuccess = response.data;
        isRated = true;
        setSaveRatingStatus(StatusUtil.success);
      } else if (response.statusUtil == StatusUtil.error) {
        errorMessage = response.errorMessage;
        setSaveRatingStatus(StatusUtil.error);
      }
    } catch (e) {
      errorMessage = "an  error occurred: $e";
      setSaveRatingStatus(StatusUtil.error);
    }
  }

  Future<void> loadUserRating(String carId, String email) async {
    _isCarRatedStatus = StatusUtil.loading;
    notifyListeners();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("rating")
        .where("carId", isEqualTo: carId)
        .where("email", isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var userRating = snapshot.docs.first.data() as Map<String, dynamic>;
      ratingController.text = userRating["rating"];
      isRated = true;
      setSaveIsCarRatedStatus(StatusUtil.success);
    } else {
      isRated = false;
      setSaveIsCarRatedStatus(StatusUtil.none);
    }
  }

  // Future<void> loadUserRating(String carId, String email) async {
  //   try {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('ratings')
  //         .doc(carId)
  //         .collection('userRatings')
  //         .doc(email)
  //         .get();

  //     if (doc.exists) {
  //       isRated = true;
  //       ratingController.text = doc.data()?['rating']?.toString() ?? "0";
  //     } else {
  //       isRated = false;
  //       ratingController.text = "0";
  //     }
  //   } catch (e) {
  //     isRated = false;
  //   }
  //   notifyListeners();
  // }

  Future<Map<String, dynamic>> getCarRatingDetails(String carId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("rating")
          .where("carId", isEqualTo: carId)
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'averageRating': 0.0,
          'numberOfRatings': 0,
        };
      }

      double totalRating = 0.0;
      int numberOfRatings = snapshot.docs.length;

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalRating += double.tryParse(data["rating"]) ?? 0.0;
      }

      double averageRating = totalRating / numberOfRatings;

      return {
        'averageRating': averageRating,
        'numberOfRatings': numberOfRatings,
      };
    } catch (e) {
      // Handle any errors here
      print("Error fetching car ratings: $e");
      return {
        'averageRating': 0.0,
        'numberOfRatings': 0,
      };
    }
  }

  Future<void> calculateAverageRating(String carId) async {
    try {
      QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
          .collection("rating")
          .where("carId", isEqualTo: carId)
          .get();

      if (ratingSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in ratingSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          totalRating += double.parse(data["rating"]);
        }
        double average = totalRating / ratingSnapshot.docs.length;

        ratingList[carId] = [average]; // Store in the list using carId as key

        int noOfRatings = ratingSnapshot.docs.length;
        totalNoOfRatings[carId] = [noOfRatings];

        // Update Firestore carsDb collection
        await FirebaseFirestore.instance
            .collection("carsDb")
            .doc(carId)
            .update({
          "averageRatings": average,
          "totalNoOfRatings": noOfRatings,
        });
      } else {
        ratingList[carId] = [0.0]; // Default to 0 if no ratings found
        totalNoOfRatings[carId] = [0];

        // Update Firestore with defaults
        await FirebaseFirestore.instance
            .collection("carsDb")
            .doc(carId)
            .update({
          "averageRatings": 0.0,
          "totalNoOfRatings": 0,
        });
      }

      notifyListeners();
    } catch (e) {
      print("Error calculating average rating: $e");
    }
  }

  // Future<void> saveRating({String? id, String? email}) async {
  //   if (_saveRatingStatus != StatusUtil.loading) {
  //     setSaveRatingStatus(StatusUtil.loading);
  //   }

  //   Rating rateCar = Rating(
  //     ratingId: ratingId,
  //     rating: ratingController.text,
  //     carId: id,
  //     email: email,
  //   );

  //   ApiResponse response = await ratingService.saveRating(rateCar);

  //   if (response.statusUtil == StatusUtil.success) {
  //     isSuccess = response.data;
  //     setSaveRatingStatus(StatusUtil.success);
  //   } else if (response.statusUtil == StatusUtil.error) {
  //     errorMessage = response.errorMessage;
  //     setSaveRatingStatus(StatusUtil.error);
  //   }
  // }
}
