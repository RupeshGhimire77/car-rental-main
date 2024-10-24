import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/shared/custom_book_button.dart';
import 'package:flutter_application_1/shared/custom_book_textfield.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DescriptionPage extends StatefulWidget {
  final Car? car;
  const DescriptionPage({super.key, this.car});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  void initState() {
    if (widget.car != null) {
      var provider = Provider.of<CarProvider>(context, listen: false);
      provider.id = widget.car!.id ?? "";
      provider.model = widget.car!.model ?? "";
      provider.year = widget.car!.year ?? "";
      provider.image = widget.car!.image ?? "";
      provider.brand = widget.car!.brand ?? "";
      provider.vehicalType = widget.car!.vehicleType ?? "";
      provider.seatingCapacity = widget.car!.seatingCapacity ?? "";
      provider.fuelType = widget.car!.fuelType ?? "";
      provider.mileage = widget.car!.mileage ?? "";
      provider.rentalPrice = widget.car!.rentalPrice ?? "";
    }
    super.initState();
    getValue();
    getCarData();

    _selectedStartDate = NepaliDateTime.now();
    _startDateController.text = _formatNepaliDate(_selectedStartDate!);
  }

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  NepaliDateTime? _selectedStartDate = NepaliDateTime.now();
  NepaliDateTime? _selectedEndDate;

  TimeOfDay? _selectedPickUpTime;
  TimeOfDay? _selectedDropTime;

  TextEditingController _pickUpTimeController = TextEditingController();
  TextEditingController _dropTimeController = TextEditingController();

  final TimeOfDay _minTime = TimeOfDay(hour: 7, minute: 0); // 7 AM
  final TimeOfDay _maxTime = TimeOfDay(hour: 19, minute: 0); // 7 PM

  String? name, email, role;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        name = prefs.getString("name");
        email = prefs.getString("email");
        role = prefs.getString("role");
      });
    });
  }

  getCarData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<CarProvider>(context, listen: false);
        await provider.getCar();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  String? model,
      year,
      image,
      brand,
      vehicalType,
      seatingCapacity,
      fuelType,
      mileage,
      rentalPrice;

  final List<Map<String, List<String>>> places = [
    {
      'Dhulikhel': [
        'Dhulikhel Bus Park',
        'Bhaktapur Durbar Square',
        'Dhulikhel Hospital',
        'Kali Temple',
        'Buddha Stupa',
      ]
    },
    {
      'Panauti': [
        'Panauti Bus Park',
        'Panauti Museum',
        'Indreshwor Mahadev Temple',
        'Brahmayani Temple',
        'Panauti Heritage Area',
      ]
    },
    {
      'Banepa': [
        'Banepa Bus Park',
        'Bhimsen Temple',
        'Banepa Durbar Square',
        'Kankrej Bhanjyang',
        'Khadgakot',
      ]
    },
    {
      'Kalaiya': [
        'Kalaiya Market',
        'Kalaiya Bus Park',
      ]
    },
    {
      'Nala': [
        'Nala Bus Park',
        'Nala Temple',
      ]
    },
    {
      'Namobuddha': [
        'Namobuddha Monastery',
        'Namobuddha Stupa',
      ]
    },
    {
      'Sankhu': [
        'Sankhu Bus Park',
        'Sankhu Durbar Square',
        'Bajrayogini Temple',
      ]
    },
    {
      'Kavre': [
        'Kavre Bus Park',
        'Various local markets',
      ]
    },
    {
      'Bhakundebesi': [
        'Bhakundebesi Market',
        'Local temples and shrines',
      ]
    },
  ];

  // Flatten the list to get all place names
  List<String> getAllPlaces() {
    List<String> allPlaces = [];
    for (var place in places) {
      place.forEach((key, value) {
        allPlaces.addAll(value); // Add all locations from each place
      });
    }
    return allPlaces;
  }

  File file = File("");
  String? downloadUrl;

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    List<String> allPlaces = getAllPlaces();
    return Scaffold(
      backgroundColor: Color(0xff771616),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF771616),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8, left: 20),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/Jackie-Chan.jpeg"),

            // backgroundColor: Colors.transparent,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8),
          child: Text(
            name ?? "no name",
            // "",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 8),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 27.5,
                )),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<CarProvider>(
            builder: (context, carProvider, child) => Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(carProvider.image!),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Model: ${carProvider.model ?? ""}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Year: " + carProvider.year! ?? "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vehical Type: ${carProvider.vehicalType ?? ""}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Fuel Type: ${carProvider.fuelType ?? ""}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Seating Capacity: ${carProvider.seatingCapacity ?? ""}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Mileage: ${carProvider.mileage ?? ""}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        // Text(
                        //   "TransmissionType: Dont know",
                        //   style: TextStyle(color: Colors.white, fontSize: 20),
                        // ),
                        Text(
                          "Brand: ${carProvider.brand ?? ""}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Rental Price: Rs. ${carProvider.rentalPrice ?? ""}/day",
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Container(
                    color: Color(0xff181A1B),
                    height: MediaQuery.of(context).size.height * .68,
                    width: MediaQuery.of(context).size.width * .9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Consumer<BookCarProvider>(
                        builder: (context, bookCarProvider, child) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pick up Point",
                                style: TextStyle(
                                    color: Color(0xffC3BEB6), fontSize: 16)),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return allPlaces.where((place) => place
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String selection) {
                                bookCarProvider.setPickUpPoint(selection);
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return CustomLocationTextfield(
                                  hintText: "Pick up Location",
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            Text("Destination Point",
                                style: TextStyle(
                                    color: Color(0xffC3BEB6), fontSize: 16)),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return allPlaces.where((place) => place
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (String selection) {
                                bookCarProvider.setDestinationPoint(selection);
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return CustomLocationTextfield(
                                  // enabled: false,
                                  hintText: "Banepa, Godamchwok",
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  readOnly: true,
                                );
                              },
                            ),
                            Center(
                              child: Text(
                                "You can't change the destination location.",
                                style: TextStyle(
                                    color: Colors.orangeAccent, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Start Date",
                                        style: TextStyle(
                                          color: Color(0xffC3BEB6),
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async =>
                                            await _selectStartDate(context),
                                        child: AbsorbPointer(
                                          child: CustomBookTextfield(
                                            controller: _startDateController,
                                            hintText: "Start Date",
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                await _selectStartDate(context);
                                              },
                                              icon: Icon(
                                                Icons.calendar_month,
                                                color: Color(0xff7B776D),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "End Date",
                                        style: TextStyle(
                                          color: Color(0xffC3BEB6),
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async =>
                                            await _selectEndDate(context),
                                        child: AbsorbPointer(
                                          child: CustomBookTextfield(
                                            controller: _endDateController,
                                            hintText: "End Date",
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                await _selectEndDate(context);
                                              },
                                              icon: Icon(
                                                Icons.calendar_month,
                                                color: Color(0xff7B776D),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pick up Time",
                                        style: TextStyle(
                                          color: Color(0xffC3BEB6),
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async =>
                                            await _selectPickUpTime(context),
                                        child: AbsorbPointer(
                                          child: CustomBookTextfield(
                                            controller: bookCarProvider
                                                .pickUpTimeController,
                                            suffixIcon: IconButton(
                                              onPressed: () async {
                                                await _selectPickUpTime(
                                                    context); // Call pick up time function
                                              },
                                              icon: Icon(
                                                Icons.watch_later_outlined,
                                                color: Color(0xff7B776D),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Drop Time",
                                        style: TextStyle(
                                          color: Color(0xffC3BEB6),
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async =>
                                            await _selectDropTime(context),
                                        child: AbsorbPointer(
                                          child: CustomBookTextfield(
                                            controller: bookCarProvider
                                                .dropTimeController,
                                            // controller:
                                            //     _dropTimeController, // Link the controller
                                            suffixIcon:
                                                // IconButton(
                                                //   onPressed: () async {
                                                //     await _selectDropTime(
                                                //         context); // Call drop time function
                                                //   },icon:
                                                Icon(
                                              Icons.watch_later_outlined,
                                              color: Color(0xff7B776D),
                                            ),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "Please select your driving License before booking.",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.17,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: file.path.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : (downloadUrl != null)
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  downloadUrl!,
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  "assets/images/background.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 60),
                                    child: CustomBookButton(
                                        onPressed: () {
                                          pickImage();
                                        },
                                        child: loader == true
                                            ? CircularProgressIndicator()
                                            : Text(
                                                "Upload Driving License",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              )),
                                  ),
                                ),
                                if (downloadUrl != null)
                                  Visibility(
                                    visible: false,
                                    child: CustomTextFormField(
                                      controller: bookCarProvider
                                          .setBookCarImage(downloadUrl!),
                                      labelText: "Car Image",
                                    ),
                                  ),
                              ],
                            ),
                            CustomBookButton(
                                onPressed: () {
                                  if (bookCarProvider.pickUpPointController.text.isEmpty ||
                                      bookCarProvider.destinationPointController
                                          .text.isEmpty ||
                                      bookCarProvider
                                          .startDateController.text.isEmpty ||
                                      bookCarProvider
                                          .endDateController.text.isEmpty ||
                                      bookCarProvider
                                          .pickUpTimeController.text.isEmpty ||
                                      bookCarProvider
                                          .dropTimeController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please fill in all fields')),
                                    );
                                    return;
                                  }
                                  bookCarProvider
                                      .setStartDate(_startDateController.text);
                                  bookCarProvider
                                      .setEndDate(_endDateController.text);
                                  bookCarProvider.setPickUpTime(bookCarProvider
                                      .pickUpTimeController.text);
                                  bookCarProvider.setDropTime(
                                      bookCarProvider.dropTimeController.text);

                                  print(
                                      "Pick Up Time: ${_pickUpTimeController.text}");
                                  print(
                                      "Drop Time: ${_dropTimeController.text}");

                                  // pickImage();
                                  bookCarProvider.saveBookCar();
                                  if (bookCarProvider.isSuccess) {
                                    Helper.displaySnackBar(context,
                                        "Successfully Booked the car.");
                                  } else {
                                    Helper.displaySnackBar(
                                        context, "Couldn't book the car.");
                                  }
                                  print(
                                      "Pick Up Time: ${_pickUpTimeController.text}");
                                  print(
                                      "Drop Time: ${_dropTimeController.text}");
                                  setState(() {});
                                },
                                child:
                                    // loader == true
                                    // ? CircularProgressIndicator():
                                    Text(
                                  "Book Now",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    NepaliDateTime? pickedDate = await showMaterialDatePicker(
      context: context,
      initialDate: _selectedStartDate!,
      firstDate: NepaliDateTime.now(),
      lastDate: NepaliDateTime(
        NepaliDateTime.now().year,
        NepaliDateTime.now().month + 1,
        NepaliDateTime.now().day,
      ),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
        _startDateController.text = _formatNepaliDate(pickedDate);

        // Update BookCarProvider
        Provider.of<BookCarProvider>(context, listen: false)
            .setStartDate(_startDateController.text);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    NepaliDateTime? pickedDate = await showMaterialDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? _selectedStartDate!,
      firstDate: _selectedStartDate!,
      lastDate: NepaliDateTime(
        _selectedStartDate!.year,
        _selectedStartDate!.month + 1,
        _selectedStartDate!.day,
      ),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedEndDate = pickedDate;
        _endDateController.text = _formatNepaliDate(pickedDate);

        // Update BookCarProvider
        Provider.of<BookCarProvider>(context, listen: false)
            .setEndDate(_endDateController.text);
      });
    }
  }

  String _formatNepaliDate(NepaliDateTime date) {
    return NepaliDateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectPickUpTime(BuildContext context) async {
    TimeOfDay? pickedTime = await _showCustomTimePicker(context);

    if (pickedTime != null) {
      setState(() {
        _selectedPickUpTime = pickedTime;
        _pickUpTimeController.text = pickedTime.format(context);

        // Update provider with the selected pickup time
        Provider.of<BookCarProvider>(context, listen: false)
            .setPickUpTime(_pickUpTimeController.text);
      });
    }
  }

  Future<void> _selectDropTime(BuildContext context) async {
    TimeOfDay? pickedTime = await _showCustomTimePicker(context);

    if (pickedTime != null) {
      setState(() {
        _selectedDropTime = pickedTime;
        _dropTimeController.text = pickedTime.format(context);

        // Update provider with the selected drop time
        Provider.of<BookCarProvider>(context, listen: false)
            .setDropTime(_dropTimeController.text);
      });
    }
  }

// Function to select pick up time
//   Future<void> _selectPickUpTime(BuildContext context) async {
//     TimeOfDay? pickedTime = await _showCustomTimePicker(context);

//     if (pickedTime != null) {
//       setState(() {
//         _selectedPickUpTime = pickedTime;
//         _pickUpTimeController.text = pickedTime.format(context);
//       });
//     }
//   }

// // Function to select drop time with 30-minute intervals
//   Future<void> _selectDropTime(BuildContext context) async {
//     TimeOfDay? pickedTime = await _showCustomTimePicker(context);

//     if (pickedTime != null) {
//       setState(() {
//         _selectedDropTime = pickedTime;
//         _dropTimeController.text = pickedTime.format(context);
//       });
//     }
//   }

// Custom Time Picker with 30-minute intervals
  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
    List<TimeOfDay> timeOptions = _generateTimeOptions();
    return showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Time'),
          children: timeOptions.map((time) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, time);
              },
              child: Text(time.format(context)),
            );
          }).toList(),
        );
      },
    );
  }

// Generate time options in 30-minute intervals
  List<TimeOfDay> _generateTimeOptions() {
    List<TimeOfDay> timeOptions = [];
    int startHour = _minTime.hour;
    int endHour = _maxTime.hour;

    for (int hour = startHour; hour <= endHour; hour++) {
      timeOptions.add(TimeOfDay(hour: hour, minute: 0));
      if (hour != endHour) {
        timeOptions.add(TimeOfDay(hour: hour, minute: 30));
      }
    }
    return timeOptions;
  }

  pickImage() async {
    setState(() {
      // loader = true; // Set loader to true before upload
    });

    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User might have canceled

    file = File(image.path);
    setState(() {
      file; // Update file state for preview
    });

    try {
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref().child('Rental');
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();
      print("downloadUrl: ${downloadUrl}");

      setState(() {
        downloadUrl; // Update downloadUrl for the form field
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

class CustomLocationTextfield extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  bool readOnly;

  CustomLocationTextfield(
      {this.hintText,
      this.controller,
      this.focusNode,
      this.enabled,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: TextField(
        style: TextStyle(color: Color(0xff7B776D)),
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: Icon(Icons.location_on),
        ),
      ),
    );
  }
}
