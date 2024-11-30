class Car {
  String? id;
  String? model;
  String? year;
  String? vehicleType;
  String? seatingCapacity;
  String? brand;
  String? fuelType;
  String? mileage;
  String? rentalPrice;
  String? image;

  String? availableStatus;
  double? averageRatings;
  int? totalNoOfRatings;

  Car(
      {this.id,
      this.model,
      this.year,
      this.vehicleType,
      this.seatingCapacity,
      this.brand,
      this.fuelType,
      this.mileage,
      this.rentalPrice,
      this.image,
      this.availableStatus,
      this.averageRatings,
      this.totalNoOfRatings});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
    year = json['year'];
    vehicleType = json['vehicleType'];
    seatingCapacity = json['seatingCapacity'];
    brand = json['brand'];
    fuelType = json['fuelType'];
    mileage = json['mileage'];
    rentalPrice = json['rentalPrice'];
    image = json['image'];

    availableStatus = json['availableStatus'];

    averageRatings = json['averageRatings'];
    totalNoOfRatings = json['totalNoOfRatings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model'] = this.model;
    data['year'] = this.year;
    data['vehicleType'] = this.vehicleType;
    data['seatingCapacity'] = this.seatingCapacity;
    data['brand'] = this.brand;
    data['fuelType'] = this.fuelType;
    data['mileage'] = this.mileage;
    data['rentalPrice'] = this.rentalPrice;
    data['image'] = this.image;

    data['availableStatus'] = this.availableStatus;

    data['averageRatings'] = this.averageRatings;
    data['totalNoOfRatings'] = this.totalNoOfRatings;
    return data;
  }
}
