import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/provider/rating_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_book_button.dart';
import 'package:flutter_application_1/shared/custom_book_textfield.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Description extends StatefulWidget {
  final Car? car;
  const Description({super.key, this.car});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  void initState() {
    super.initState();
    getValue();

    _selectedStartDate = NepaliDateTime.now();
    _startDateController.text = _formatNepaliDate(_selectedStartDate!);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final ratingProvider =
    //       Provider.of<RatingProvider>(context, listen: false);
    //   final carId = widget.car?.id;
    //   final userEmail = email;

    //   if (carId != null && userEmail != null) {
    //     ratingProvider.loadUserRating(carId, userEmail);
    //   }
    // });
  }

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

  TextStyle normalText =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
  Color? white = Colors.white;

  TextStyle? detailStyle =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);

  final _formKey = GlobalKey<FormState>();

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  NepaliDateTime? _selectedStartDate = NepaliDateTime.now();
  NepaliDateTime? _selectedEndDate;

  TextEditingController _pickUpTimeController = TextEditingController();
  TextEditingController _dropTimeController = TextEditingController();

  final borderRadius = BorderRadius.circular(10.0);

  File file = File("");
  String? downloadUrl;

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    List<String> allPlaces =
        Provider.of<BookCarProvider>(context, listen: false).getAllPlaces();
    return Scaffold(
      backgroundColor: Color(0xff771616),
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _carDescription(widthSize, heightSize),
            _bookingForm(allPlaces, heightSize),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
              child: Consumer2<RatingProvider, BookCarProvider>(
                  builder: (context, ratingProvider, bookCarProvider, child) {
                ratingProvider.loadUserRating(widget.car!.id!, email!);

                return ratingProvider.isRated == true
                    ? Column(
                        children: [
                          Text(
                            "You have rated this car:",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: double.parse(
                                    ratingProvider.ratingController.text),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (_) {},
                                ignoreGestures: true,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "(${widget.car!.averageRatings!.toStringAsFixed(1)}/5) ${widget.car!.totalNoOfRatings!}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            "Rate This Car",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  ratingProvider.setRating(rating.toString());
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "(${widget.car!.averageRatings!.toStringAsFixed(2)}/5) ${widget.car!.totalNoOfRatings}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: CustomBookButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  List<QueryDocumentSnapshot> paidBookings =
                                      await bookCarProvider.getPaidBookings(
                                          email, widget.car?.id);

                                  bool hasPaidBooking = false;

                                  for (var booking in paidBookings) {
                                    Map<String, dynamic> bookingData =
                                        booking.data() as Map<String, dynamic>;

                                    bool isPaid =
                                        bookingData['isPaid'] ?? false;

                                    if (isPaid) {
                                      hasPaidBooking =
                                          true; // Mark that a paid booking exists
                                      await ratingProvider.saveRating(
                                        email: email,
                                        id: widget.car?.id,
                                      );

                                      if (ratingProvider.saveRatingStatus ==
                                          StatusUtil.success) {
                                        Helper.displaySnackBar(
                                            context, "Rating Successful!");
                                      } else if (ratingProvider
                                              .saveRatingStatus ==
                                          StatusUtil.error) {
                                        Helper.displaySnackBar(
                                            context,
                                            ratingProvider.errorMessage ??
                                                "Error rating the car.");
                                      }
                                      break; // Stop further iteration once a paid booking is found
                                    }
                                  }

                                  if (!hasPaidBooking) {
                                    // Only display this if no paid booking was found
                                    Helper.displaySnackBar(context,
                                        "You have not rented this car.");
                                  }
                                }
                              },
                              child: Text(
                                "Rate It",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Padding _bookingForm(List<String> allPlaces, double heightSize) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.only(top: 8),
        // height: heightSize * .2,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xff181A1B),
        ),
        child: Consumer<BookCarProvider>(
            builder: (context, bookCarProvider, child) {
          return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Pick Up Point",
                      style: TextStyle(color: Color(0xffC3BEB6), fontSize: 16),
                    ),
                  ),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return allPlaces.where((place) => place
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8),
                    child: Text(
                      "Destination Point",
                      style: TextStyle(color: Color(0xffC3BEB6), fontSize: 16),
                    ),
                  ),
                  CustomLocationTextfield(
                    readOnly: true,
                    hintText: "Banepa, Godamchwok",
                  ),
                  Center(
                    child: Text(
                      "You can't change the destination location.",
                      style:
                          TextStyle(color: Colors.orangeAccent, fontSize: 12),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildDateField(
                          label: "Pick Up Date",
                          controller: _startDateController,
                          onTap: () => _selectStartDate(context),
                        ),
                      ),
                      Expanded(
                        child: buildDateField(
                          label: "Drop Date",
                          controller: _endDateController,
                          onTap: () => _selectEndDate(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 8),
                              child: Text(
                                "Pick Up Time",
                                style: TextStyle(
                                    color: Color(0xffC3BEB6), fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async =>
                                  await _selectPickUpTime(context),
                              child: AbsorbPointer(
                                child: CustomBookTextfield(
                                  controller:
                                      bookCarProvider.pickUpTimeController,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 8),
                              child: Text(
                                "Drop Time",
                                style: TextStyle(
                                    color: Color(0xffC3BEB6), fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async => await _selectDropTime(context),
                              child: AbsorbPointer(
                                child: CustomBookTextfield(
                                  controller:
                                      bookCarProvider.dropTimeController,
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
                    child: Center(
                      child: Text(
                        "Please select your driving License before booking.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: heightSize * .125,
                            child: file != null && file.path.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: borderRadius,
                                    child: Image.file(
                                      file,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : (downloadUrl != null)
                                    ? ClipRRect(
                                        borderRadius: borderRadius,
                                        child: Image.network(
                                          downloadUrl!,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: borderRadius,
                                        child: Image.asset(
                                          "assets/images/background.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: CustomBookButton(
                                onPressed: () async {
                                  await pickImage();
                                },
                                child: Text(
                                  "Upload Driving License",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (downloadUrl != null)
                    Visibility(
                      visible: false,
                      child: CustomTextFormField(
                        controller:
                            bookCarProvider.setBookCarImage(downloadUrl!),
                        labelText: "Car Image",
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: CustomBookButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (bookCarProvider
                                    .pickUpPointController.text.isEmpty ||
                                bookCarProvider
                                    .startDateController.text.isEmpty ||
                                bookCarProvider
                                    .endDateController.text.isEmpty ||
                                bookCarProvider
                                    .pickUpTimeController.text.isEmpty ||
                                bookCarProvider
                                    .dropTimeController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill in all fields')),
                              );
                              return;
                            }
                            bookCarProvider
                                .setStartDate(_startDateController.text);
                            bookCarProvider.setEndDate(_endDateController.text);
                            bookCarProvider.setPickUpTime(
                                bookCarProvider.pickUpTimeController.text);
                            bookCarProvider.setDropTime(
                                bookCarProvider.dropTimeController.text);

                            await bookCarProvider.saveBookCar(
                                email: email, id: widget.car?.id);

                            if (bookCarProvider.isSuccess &&
                                bookCarProvider.saveBookCarStatus ==
                                    StatusUtil.success) {
                              Helper.displaySnackBar(
                                  context, "Successfully Booked the car.");
                              Navigator.pop(context);
                            } else {
                              Helper.displaySnackBar(
                                  context, "Couldn't book the car.");
                            }

                            // } else {
                            //   Helper.displaySnackBar(context,
                            //       "Payment failed. Booking was not saved.");
                            // }

                            setState(() {});
                          }
                        },
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  )
                ],
              ));
        }),
      ),
    );
  }

  Column _carDescription(double widthSize, double heightSize) {
    return Column(
      children: [
        widget.car?.image == null || widget.car!.image!.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: widthSize,
                  height: heightSize * .22,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/sedan.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  // width: widthSize,
                  // height: heightSize * .106,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.car!.image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(10),
            // height: heightSize * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(
                        1.5), // First column takes as much space as it needs
                    1: FlexColumnWidth(
                        1), // Second column takes the remaining space
                  },
                  // border: TableBorder.all(
                  //     borderRadius: BorderRadius.circular(1)),
                  children: [
                    TableRow(
                      children: [
                        _tableCell(
                          "Model: " + widget.car!.model!,
                        ),
                        _tableCell(
                          "Year: " + widget.car!.year!,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        _tableCell("Vehicle Type: " + widget.car!.vehicleType!),
                        _tableCell("Fuel Type: " + widget.car!.fuelType!),
                      ],
                    ),
                    TableRow(
                      children: [
                        _tableCell("Seating Capacity: " +
                            widget.car!.seatingCapacity!),
                        _tableCell("Mileage: " + widget.car!.mileage!),
                      ],
                    ),
                    TableRow(
                      children: [
                        _tableCell("Brand: " + widget.car!.brand!),
                        _tableCell(""),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.2)),
                  child: Column(
                    children: [
                      Text(
                        "Rental Price: Rs." + widget.car!.rentalPrice! + "/Day",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.yellow,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Status: " + widget.car!.availableStatus!,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.yellow,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _tableCell(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: detailStyle,
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Color(0xff771616),
      title: Text(
        name ?? '',
        style: normalText,
      ),
      leading: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final userDetails = userProvider.getUserByEmail(email);

          return userDetails?.image == null || userDetails?.image == ""
              ? const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    // radius: 25,
                    backgroundImage:
                        AssetImage("assets/images/background_person.png"),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    // radius: 25,
                    backgroundImage: NetworkImage("${userDetails?.image}"),
                  ),
                );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.notifications_active,
            size: 27.5,
            color: white,
          ),
        )
      ],
    );
  }

  Widget buildDateField({
    required String label,
    required TextEditingController controller,
    required Function onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8),
          child: Text(label,
              style: TextStyle(color: Color(0xffC3BEB6), fontSize: 16)),
        ),
        GestureDetector(
          onTap: () => onTap(),
          child: AbsorbPointer(
            child: CustomBookTextfield(
              controller: controller,
              hintText: "Select Date",
              suffixIcon: IconButton(
                onPressed: () => onTap(),
                icon: Icon(Icons.calendar_month, color: Color(0xff7B776D)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    NepaliDateTime? pickedDate = await showMaterialDatePicker(
      context: context,
      initialDate: _selectedStartDate!,
      firstDate: NepaliDateTime.now(),
      lastDate: _selectedEndDate ??
          NepaliDateTime(
            NepaliDateTime.now().year,
            NepaliDateTime.now().month + 1,
            NepaliDateTime.now().day,
          ),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
        _startDateController.text = _formatNepaliDate(pickedDate);

        // Adjust end date if needed
        if (_selectedEndDate != null && pickedDate.isAfter(_selectedEndDate!)) {
          _selectedEndDate = null;
          _endDateController.text = '';
        }

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
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _pickUpTimeController.text = pickedTime.format(context);

        // Update provider with the selected pickup time
        Provider.of<BookCarProvider>(context, listen: false)
            .setPickUpTime(_pickUpTimeController.text);
      });
    }
  }

  Future<void> _selectDropTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        // _selectedDropTime = pickedTime;
        _dropTimeController.text = pickedTime.format(context);

        // Update provider with the selected drop time
        Provider.of<BookCarProvider>(context, listen: false)
            .setDropTime(_dropTimeController.text);
      });
    }
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

      setState(() {
        downloadUrl; // Update downloadUrl for the form field
        loader = false; // Hide loader after successful upload
      });
    } catch (e) {
      setState(() {
        loader = false; // Hide loader even on error
      });
      // Print error for debugging
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
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
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
