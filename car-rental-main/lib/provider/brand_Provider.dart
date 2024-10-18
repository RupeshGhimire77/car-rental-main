import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/brand.dart';
import 'package:flutter_application_1/service/brand_service.dart';
import 'package:flutter_application_1/service/brand_service_impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class BrandProvider extends ChangeNotifier {
  String? brandId, brandName;
  String? errorMessage;

  TextEditingController? brandImageTextField;
  bool isSuccess = false;
  bool brandDeleteSuccessful = false;

  // setBrandId(value) {
  //   brandId = value;
  // }

  setBrandImage(value) {
    brandImageTextField = TextEditingController(text: value);
  }

  setBrandName(value) {
    brandName = value;
  }

  List<Brand> brandList = [];
  BrandService brandService = BrandServiceImpl();

  StatusUtil _saveBrandStatus = StatusUtil.none;
  StatusUtil get saveBrandStatus => _saveBrandStatus;

  StatusUtil _getBrandStatus = StatusUtil.none;
  StatusUtil get getBrandStatus => _getBrandStatus;

  StatusUtil _deleteBrandStatus = StatusUtil.none;
  StatusUtil get deleteBrandStatus => _deleteBrandStatus;

  setDeleteBrandStatus(StatusUtil status) {
    _deleteBrandStatus = status;
    notifyListeners();
  }

  setSaveBrandStatus(StatusUtil status) {
    _saveBrandStatus = status;
    notifyListeners();
  }

  setGetBrandStatus(StatusUtil status) {
    _getBrandStatus = status;
    notifyListeners();
  }

  Future<void> saveBrand() async {
    if (_saveBrandStatus != StatusUtil.loading) {
      setSaveBrandStatus(StatusUtil.loading);
    }

    Brand brand = Brand(
        brandId: brandId,
        brandImage: brandImageTextField?.text,
        brandName: brandName);

    ApiResponse response = await brandService.saveBrand(brand);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = true;
      setSaveBrandStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setSaveBrandStatus(StatusUtil.error);
    }
  }

  Future<void> getBrand() async {
    if (_getBrandStatus != StatusUtil.loading) {
      setGetBrandStatus(StatusUtil.loading);
    }

    ApiResponse response = await brandService.getBrand();

    if (response.statusUtil == StatusUtil.success) {
      brandList = response.data;
      setGetBrandStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetBrandStatus(StatusUtil.error);
    }
  }

  Future<void> deleteBrand(String brandId) async {
    if (_deleteBrandStatus != StatusUtil.loading) {
      setDeleteBrandStatus(StatusUtil.loading);
    }

    ApiResponse response = await brandService.deleteBrand(brandId);
    if (response.statusUtil == StatusUtil.success) {
      brandDeleteSuccessful = response.data;
      setDeleteBrandStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setDeleteBrandStatus(StatusUtil.error);
    }
  }
}
