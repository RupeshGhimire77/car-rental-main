class Rating {
  String? rating;
  String? carId;
  String? email;

  Rating({this.carId, this.rating, this.email});

  Rating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    carId = json['carId'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['carId'] = this.carId;

    data['email'] = this.email;
    return data;
  }
}
