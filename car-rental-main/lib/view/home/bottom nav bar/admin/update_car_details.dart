import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/admin/admin_bottom.navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UpdateCarDetails extends StatefulWidget {
  final Car? car;
  const UpdateCarDetails({super.key, this.car});

  @override
  State<UpdateCarDetails> createState() => _UpdateCarDetailsState();
}

class _UpdateCarDetailsState extends State<UpdateCarDetails> {
  bool isLoading = true;
  bool loader = false;
  File file = File("");
  String? downloadUrl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _initializeCarData(widget.car);
    }
    getCarData(); // Fetch car data if necessary
  }

  TextEditingController carImageUpdateController = TextEditingController();

  void _initializeCarData(Car? car) {
    var provider = Provider.of<CarProvider>(context, listen: false);
    provider.id = car?.id ?? "";
    provider.model = car?.model ?? "";
    provider.year = car?.year ?? "";

    provider.image = widget.car?.image ?? "";
    provider.brand = car?.brand ?? "";
    provider.vehicalType = car?.vehicleType ?? "";
    provider.seatingCapacity = car?.seatingCapacity ?? "";
    provider.fuelType = car?.fuelType ?? "";
    provider.mileage = car?.mileage ?? "";
    provider.rentalPrice = car?.rentalPrice ?? "";

    carImageUpdateController.text = widget.car?.image ?? "";
  }

  Future<void> getCarData() async {
    setState(() => isLoading = true);
    var provider = Provider.of<CarProvider>(context, listen: false);
    await provider.getCar(); // Fetch the car list if needed
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var car = widget.car; // Get the car being edited

    return Scaffold(
        backgroundColor: Color(0xff771616),
        appBar: AppBar(
          backgroundColor: Color(0xff771616),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // Go back without saving
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Center(
            child: Text(
              "Update Car Details",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
        ),
        body: Consumer<CarProvider>(
          builder: (context, carProvider, child) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Display the car's image
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            car?.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          'assets/images/placeholder.png'),
                                      image: NetworkImage(car!.image!),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.190,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Image Error',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    color: Colors.grey,
                                    alignment: Alignment.center,
                                    child: Text('No Image',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    // Other form fields here...
                    CustomButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: loader == true
                            ? CircularProgressIndicator()
                            : Text(
                                "Change Image",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),

                    if (downloadUrl != null)
                      Visibility(
                        // visible: false,
                        child: CustomTextFormField(
                          initialValue: carProvider.imageTextField.toString(),
                          controller: carProvider.setImage(downloadUrl!),
                          labelText: "Car Image",
                        ),
                      ),
                    CustomTextFormField(
                      initialValue: carProvider.model,
                      labelText: modelCarStr,
                      onChanged: (p0) {
                        carProvider.setModel(p0);
                      },
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return carValidStr;
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.year,
                      onChanged: (p0) {
                        carProvider.setYear(p0);
                      },
                      labelText: carYearStr,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return carValidStr;
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.brand,
                      onChanged: (p0) {
                        carProvider.setBrand(p0);
                      },
                      labelText: brandStr,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return carValidStr;
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.seatingCapacity,
                      onChanged: (p0) {
                        carProvider.setSeatingCapactiy(p0);
                      },
                      labelText: seatingCapacityStr,
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.vehicalType,
                      onChanged: (p0) {
                        carProvider.setVehicalType(p0);
                      },
                      labelText: vehicalTypeStr,
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.fuelType,
                      onChanged: (p0) {
                        carProvider.setFuelType(p0);
                      },
                      labelText: fuelTypeStr,
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.mileage,
                      onChanged: (p0) {
                        carProvider.setMileage(p0);
                      },
                      labelText: mileageStr,
                    ),
                    CustomTextFormField(
                      initialValue: carProvider.rentalPrice,
                      onChanged: (p0) {
                        carProvider.setRentalPrice(p0);
                      },
                      labelText: rentalPriceStr,
                      keyboardType: TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CustomButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await carProvider.updateCar();
                              if (carProvider.saveCarStatus ==
                                  StatusUtil.success) {
                                await Helper.displaySnackBar(
                                    context, "Car Successfully Saved.");
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AdminBottomNavBar(
                                //       initialIndex: 0,
                                //     ),
                                //   ),
                                //   (route) => false,
                                // );
                                Navigator.pop(context);
                              }
                            } else if (carProvider.saveCarStatus ==
                                StatusUtil.error) {
                              Helper.displaySnackBar(
                                  context, "Car Could not be Saved.");
                            }
                          },
                          child: carProvider.saveCarStatus == StatusUtil.loading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Update Car',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                    ),
                  ],
                ),
              )),
        ));
  }

  Future<void> pickImage() async {
    setState(() {
      loader = true; // Show loader before upload
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User might have canceled

    file = File(image.path);
    setState(() {});

    try {
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref().child('Rental');
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();

      setState(() {
        loader = false; // Hide loader after successful upload
      });
    } catch (e) {
      setState(() {
        loader = false; // Hide loader even on error
      });
      print(e); // Print error for debugging
    }
  }
}
