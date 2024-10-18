import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_response.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/service/car_service.dart';
import 'package:flutter_application_1/service/car_service_Impl.dart';
import 'package:flutter_application_1/utils/status_util.dart';

class CarProvider extends ChangeNotifier {
  String? id = "",
      model = "",
      year = "",
      image = "",
      brand = "",
      vehicalType = "",
      seatingCapacity = "",
      fuelType = "",
      mileage = "",
      rentalPrice = "";
  String? errorMessage = "";
  // String? id;
  TextEditingController? imageTextField;
  bool carDeleteSuccessfull = false;

  bool isSuccess = false;
  // setId(value) {
  //   id = value;
  // }

  setModel(value) {
    model = value;
  }

  setYear(value) {
    year = value;
  }

  setImage(value) {
    imageTextField = TextEditingController(text: value);
  }

  setBrand(value) {
    brand = value;
  }

  setVehicalType(value) {
    vehicalType = value;
  }

  setSeatingCapactiy(value) {
    seatingCapacity = value;
  }

  setFuelType(value) {
    fuelType = value;
  }

  setMileage(value) {
    mileage = value;
  }

  setRentalPrice(value) {
    rentalPrice = value;
  }

  List<Car> carList = [];
  CarService carService = CarServiceImpl();

  StatusUtil _saveCarStatus = StatusUtil.none;
  StatusUtil get saveCarStatus => _saveCarStatus;

  StatusUtil _getCarStatus = StatusUtil.none;
  StatusUtil get getCarStatus => _getCarStatus;

  StatusUtil _deleteCarStatus = StatusUtil.none;
  StatusUtil get deleteCarStatus => _deleteCarStatus;

  // StatusUtil _getDeleteStatus = StatusUtil.none;
  // StatusUtil get getDeleteStatus => _getDeleteStatus;

  StatusUtil _getCarDetailsStatus = StatusUtil.none;
  StatusUtil get getCarDetailsStatus => _getCarDetailsStatus;

  setgetCarDetailsStatus(StatusUtil status) {
    _getCarDetailsStatus = status;
    notifyListeners();
  }

  // setgetDeleteStatus(StatusUtil status) {
  //   _getDeleteStatus = status;
  //   notifyListeners();
  // }

  setDeleteCarStatus(StatusUtil status) {
    _deleteCarStatus = status;
    notifyListeners();
  }

  setSaveCarStatus(StatusUtil status) {
    _saveCarStatus = status;
    notifyListeners();
  }

  setGetCarStatus(StatusUtil status) {
    _getCarStatus = status;
    notifyListeners();
  }

  Future<void> saveCar() async {
    if (_saveCarStatus != StatusUtil.loading) {
      setSaveCarStatus(StatusUtil.loading);
    }

    // late ApiResponse response;
    Car car = Car(
        id: id,
        model: model,
        year: year,
        image: imageTextField?.text,
        // image: image,
        vehicleType: vehicalType,
        fuelType: fuelType,
        mileage: mileage,
        brand: brand,
        seatingCapacity: seatingCapacity,
        rentalPrice: rentalPrice);

    // if (id!.isNotEmpty) {
    //   response = await carService.updateCarData(car);
    // } else {
    ApiResponse response = await carService.saveCar(car);
    // }

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = true;
      setSaveCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setSaveCarStatus(StatusUtil.error);
    }
  }

  Future<void> updateCar() async {
    if (_saveCarStatus != StatusUtil.loading) {
      setSaveCarStatus(StatusUtil.loading);
    }

    // late ApiResponse response;
    Car car = Car(
        id: id,
        model: model,
        year: year,
        image: imageTextField?.text,
        // image: image,
        vehicleType: vehicalType,
        fuelType: fuelType,
        mileage: mileage,
        brand: brand,
        seatingCapacity: seatingCapacity,
        rentalPrice: rentalPrice);

    ApiResponse response = await carService.updateCarData(car);

    if (response.statusUtil == StatusUtil.success) {
      isSuccess = true;
      setSaveCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setSaveCarStatus(StatusUtil.error);
    }
  }

  Future<void> getCar() async {
    if (_getCarStatus != StatusUtil.loading) {
      setGetCarStatus(StatusUtil.loading);
    }

    ApiResponse response = await carService.getCar();
    if (response.statusUtil == StatusUtil.success) {
      carList = response.data;
      setGetCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.errorMessage;
      setGetCarStatus(StatusUtil.error);
    }
  }

  Future<void> deleteCar(String id) async {
    if (_deleteCarStatus != StatusUtil.loading) {
      setDeleteCarStatus(StatusUtil.loading);
    }

    ApiResponse response = await carService.deleteCar(id);
    if (response.statusUtil == StatusUtil.success) {
      carDeleteSuccessfull = response.data;
      setDeleteCarStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setDeleteCarStatus(StatusUtil.error);
    }
  }

  Future<void> getCarDetails() async {
    if (_getCarDetailsStatus != StatusUtil.loading) {
      setgetCarDetailsStatus(StatusUtil.loading);
    }
    Car car = Car(
        id: id,
        model: model,
        year: year,
        image: imageTextField?.text,
        // image: image,
        vehicleType: vehicalType,
        fuelType: fuelType,
        mileage: mileage,
        brand: brand,
        seatingCapacity: seatingCapacity,
        rentalPrice: rentalPrice);

    ApiResponse response = await carService.getCarDetails(car);
    if (response.statusUtil == StatusUtil.success) {
      // isSuccess = response.data;
      carList = response.data;
      setgetCarDetailsStatus(StatusUtil.success);
    } else if (response.statusUtil == StatusUtil.error) {
      errorMessage = response.data;
      setgetCarDetailsStatus(StatusUtil.error);
    }
    notifyListeners();
  }
}
