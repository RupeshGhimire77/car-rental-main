import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/rating.dart';
import 'package:flutter_application_1/service/rating_service.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';

class RatingServiceImpl implements RatingService {
  @override
  Future<ApiResponse> saveRating(Rating rating) async {
    bool isSuccess = false;

    if (await Helper.isInternetConnectionAvailable()) {
      try {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection("rating")
            .add(rating.toJson());

        // Set bookCarId to the generated ID
        rating.ratingId = docRef.id;

        // Update the document with the new bookCarId field
        await docRef.update({'ratingId': rating.ratingId});

        isSuccess = true;
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
  Future<ApiResponse> getAverageRating(String carId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rating')
          .where('carId', isEqualTo: carId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return ApiResponse(
          statusUtil: StatusUtil.success,
          data: 0.0,
        ); // No ratings for the car
      }

      double totalRating = 0.0;
      int numberOfRatings = querySnapshot.docs.length;

      for (var doc in querySnapshot.docs) {
        totalRating += (doc.data() as Map<String, dynamic>)['rating'];
      }

      double averageRating = totalRating / numberOfRatings;

      return ApiResponse(
        statusUtil: StatusUtil.success,
        data: averageRating,
      );
    } catch (e) {
      return ApiResponse(
        statusUtil: StatusUtil.error,
        errorMessage: 'Error fetching average rating: $e',
      );
    }
  }

  // Future<ApiResponse> saveRating(Rating rating) async {
  //   if (await Helper.isInternetConnectionAvailable()) {
  //     try {
  //       DocumentReference docRef = await FirebaseFirestore.instance
  //           .collection("ratings")
  //           .add(rating.toJson());

  //       rating.ratingId = docRef.id; // Set document ID as rating ID
  //       await docRef.update({'ratingId': rating.ratingId});

  //       return ApiResponse(statusUtil: StatusUtil.success, data: true);
  //     } catch (e) {
  //       return ApiResponse(
  //           statusUtil: StatusUtil.error, errorMessage: e.toString());
  //     }
  //   } else {
  //     return ApiResponse(
  //         statusUtil: StatusUtil.error,
  //         errorMessage: "No internet connection.");
  //   }
  // }
}
