class BookCar {
  String? bookCarId;
  String? pickUpPoint;
  // String? destinationPoint;
  String? startDate;
  String? endDate;
  String? pickUpTime;
  String? dropTime;
  String? bookCarImage;

  bool? isCancelled;

  String? email;

  String? carId;
  BookCar(
      {this.bookCarId,
      this.pickUpPoint,
      // this.destinationPoint,
      this.startDate,
      this.endDate,
      this.pickUpTime,
      this.dropTime,
      this.bookCarImage,
      this.carId,
      this.email,
      this.isCancelled = false});

  BookCar.fromJson(Map<String, dynamic> json) {
    bookCarId = json['bookCarId'];
    pickUpPoint = json['pickUpPoint'] ?? '';
    // destinationPoint = json['destinationPoint'];
    startDate = json['startDate'] ?? '';
    endDate = json['endDate'] ?? '';
    pickUpTime = json['pickUpTime'] ?? '';
    dropTime = json['dropTime'] ?? '';
    bookCarImage = json['bookCarImage'] ?? '';

    carId = json['carId'] ?? '';
    email = json['email'] ?? '';

    isCancelled = json['isCancelled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookCarId'] = this.bookCarId;
    data['pickUpPoint'] = this.pickUpPoint;
    // data['destinationPoint'] = this.destinationPoint;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['pickUpTime'] = this.pickUpTime;
    data['dropTime'] = this.dropTime;
    data['bookCarImage'] = this.bookCarImage;

    data['carId'] = this.carId;
    data['email'] = this.email;

    data['isCancelled'] = this.isCancelled;
    return data;
  }
}
