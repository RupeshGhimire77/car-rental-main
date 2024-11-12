import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandSearchServiceAlgorithm {
  Future<void> saveLastSearchedBrand(String brandName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedBrand', brandName);
  }

  Future<String?> getLastSearchedBrand() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastSearchedBrand');
  }

  List<String> getSearchResults(String searchQuery, List<String> allBrands) {
    allBrands.sort((a, b) {
      if (a == searchQuery) {
        return -1;
      }
      return a.compareTo(b);
    });
    return allBrands;
  }
}
