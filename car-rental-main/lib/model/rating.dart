class Rating {
  String? rating;
  String? carId;
  String? email;
  bool? isRated;
  String? ratingId;

  Rating(
      {this.ratingId,
      this.carId,
      this.rating,
      this.email,
      this.isRated = false});

  Rating.fromJson(Map<String, dynamic> json) {
    ratingId = json['ratingId'];
    rating = json['rating'];
    carId = json['carId'];
    email = json['email'];
    isRated = json['isRated'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ratingId'] = this.ratingId;
    data['rating'] = this.rating;
    data['carId'] = this.carId;
    data['email'] = this.email;
    data['isRated'] = this.isRated;
    return data;
  }
}
