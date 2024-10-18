class Brand {
  String? brandId;
  String? brandName;
  String? brandImage;

  Brand({this.brandName, this.brandImage, this.brandId});

  Brand.fromJson(Map<String, dynamic> json) {
    brandId = json['brandId'];
    brandName = json['brandName'];
    brandImage = json['brandImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandId'] = brandId;
    data['brandName'] = brandName;
    data['brandImage'] = brandImage;
    return data;
  }
}

class BrandList {
  List<Brand> brands;

  BrandList({required this.brands});

  BrandList.fromJson(List<dynamic> json)
      : brands = json.map((i) => Brand.fromJson(i)).toList();

  List<Map<String, dynamic>> toJson() {
    return brands.map((brand) => brand.toJson()).toList();
  }
}
