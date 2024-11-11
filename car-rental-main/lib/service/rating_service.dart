import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/rating.dart';

abstract class RatingService {
  Future<ApiResponse> saveRating(Rating rating);
}
