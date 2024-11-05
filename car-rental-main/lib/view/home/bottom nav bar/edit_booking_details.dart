import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/book_car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_book_button.dart';
import 'package:flutter_application_1/shared/custom_book_textfield.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditBookingDetails extends StatefulWidget {
  // final String? id;
  final BookCar? booking;

  const EditBookingDetails({super.key, this.booking});

  @override
  State<EditBookingDetails> createState() => _EditBookingDetailsState();
}

class _EditBookingDetailsState extends State<EditBookingDetails> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController carIdController = TextEditingController();

  final TextEditingController bookCarImageController = TextEditingController();

  // final bookCarImageController = TextEditingController();

  NepaliDateTime? _selectedStartDate;
  NepaliDateTime? _selectedEndDate;

  File? file;
  String? downloadUrl;
  bool loader = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      var provider = Provider.of<BookCarProvider>(context, listen: false);
      provider.bookCarId = widget.booking?.bookCarId ?? "";

      carIdController.text = widget.booking?.carId ?? "";

      emailController.text = widget.booking?.email ?? "";

      provider.setPickUpPoint(widget.booking?.pickUpPoint ?? "");
      provider.setPickUpTime(widget.booking?.pickUpTime ?? "");
      provider.setDropTime(widget.booking?.dropTime ?? "");

      bookCarImageController.text = widget.booking?.bookCarImage ?? '';

      String? startDate = widget.booking?.startDate;
      if (startDate != null && startDate.isNotEmpty) {
        _startDateController.text = startDate;
      } else {
        _selectedStartDate = NepaliDateTime
            .now(); //come back to todays date if the date is not available
        _startDateController.text = _formatNepaliDate(_selectedStartDate!);
      }

      _endDateController.text = widget.booking?.endDate ?? "";

      // provider.setStartDate(widget.booking?.startDate ?? "");
      // provider.setEndDate(widget.booking?.endDate ?? "");
    }

    // _selectedStartDate = NepaliDateTime.now();
    // _startDateController.text = _formatNepaliDate(_selectedStartDate!);
    getValue();
    getBookCarDetails();
  }

  Future<void> getBookCarDetails() async {
    setState(() => isLoading = true);
    var provider = Provider.of<BookCarProvider>(context, listen: false);
    await provider.getBookCar(); // Fetch the car list if needed
    setState(() => isLoading = false);
  }

  Future<void> getValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString("email") ?? "";
    });
  }

  TimeOfDay? _selectedPickUpTime;
  TimeOfDay? _selectedDropTime;

  TextEditingController _pickUpTimeController = TextEditingController();
  TextEditingController _dropTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bookCar = widget.booking;
    return Scaffold(
      backgroundColor: Color(0xff771616),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 25,
                        )),
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      "Edit Details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                  color: const Color(0xff181A1B),
                  height: MediaQuery.of(context).size.height * .75,
                  width: MediaQuery.of(context).size.width * .9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Consumer2<BookCarProvider, UserProvider>(
                      builder:
                          (context, bookCarProvider, userProvider, child) =>
                              Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: false,
                            child: CustomBookTextfield(
                              // labelText: "user email: ${email}",
                              // initialValue: email ?? "",
                              controller: emailController,
                              // bookCarProvider.setCarId("${email}"),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: CustomBookTextfield(
                              labelText: "Car Id",
                              // initialValue: widget.car!.id,
                              // controller:
                              //     bookCarProvider.setCarId("${widget.car!.id}"),
                              controller: carIdController,
                            ),
                          ),

                          Text("Pick up Point",
                              style: TextStyle(
                                  color: Color(0xffC3BEB6), fontSize: 16)),
                          Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              // Implement your autocomplete logic here
                              return const Iterable<
                                  String>.empty(); // Placeholder
                            },
                            onSelected: (String selection) {
                              bookCarProvider.setPickUpPoint(selection);
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              //setting the initial value to the controller
                              textEditingController.text =
                                  bookCar?.pickUpPoint ?? "";
                              return CustomBookTextfield(
                                hintText: "Pick up Location",
                                controller: textEditingController,
                                // initialValue: bookCar!.pickUpPoint,

                                // focusNode: focusNode,
                              );
                            },
                          ),

                          SizedBox(height: 20),
                          Text("Destination Point",
                              style: TextStyle(
                                  color: Color(0xffC3BEB6), fontSize: 16)),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Color(0xff7B776D)),
                                hintText: "Banepa, Godamchwok",
                                suffixIcon: Icon(Icons.location_on)),
                          ),
                          Center(
                            child: Text(
                              "You can't change the destination location.",
                              style: TextStyle(
                                  color: Colors.orangeAccent, fontSize: 12),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start Date",
                                        style: TextStyle(
                                            color: Color(0xffC3BEB6),
                                            fontSize: 16)),
                                    GestureDetector(
                                      onTap: () async =>
                                          await _selectStartDate(context),
                                      child: AbsorbPointer(
                                        child: CustomBookTextfield(
                                          controller: _startDateController,
                                          hintText: "Start Date",
                                          suffixIcon: Icon(Icons.calendar_month,
                                              color: Color(0xff7B776D)),
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
                                    Text("End Date",
                                        style: TextStyle(
                                            color: Color(0xffC3BEB6),
                                            fontSize: 16)),
                                    GestureDetector(
                                      onTap: () async =>
                                          await _selectEndDate(context),
                                      child: AbsorbPointer(
                                        child: CustomBookTextfield(
                                          controller: _endDateController,
                                          hintText: "End Date",
                                          suffixIcon: Icon(Icons.calendar_month,
                                              color: Color(0xff7B776D)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              await _selectDropTime(
                                                  context); // Call drop time function
                                            },
                                            icon: Icon(
                                              Icons.watch_later_outlined,
                                              color: Color(0xff7B776D),
                                            ),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "Please select your driving License before booking.",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.17,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: bookCar!.bookCarImage != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/images/placeholder.png'),
                                            image: NetworkImage(
                                                bookCar.bookCarImage!),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.190,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: Text('No Image',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: CustomBookButton(
                                    onPressed: pickImage,
                                    child: loader
                                        ? CircularProgressIndicator()
                                        : Text("Upload Driving License",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Add your submit button logic here
                          if (downloadUrl != null)
                            Visibility(
                              visible: false,
                              child: Expanded(
                                child: CustomTextFormField(
                                  // controller: bookCarProvider
                                  //     .setBookCarImage(downloadUrl!),
                                  // initialValue: bookCar.bookCarImage,
                                  controller: bookCarImageController,
                                  labelText: "License Image",
                                ),
                              ),
                            ),

                          CustomBookButton(
                              onPressed: () {
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
                                    SnackBar(
                                        content:
                                            Text('Please fill in all fields')),
                                  );
                                  return;
                                }
                                bookCarProvider
                                    .setStartDate(_startDateController.text);
                                bookCarProvider
                                    .setEndDate(_endDateController.text);
                                bookCarProvider.setPickUpTime(
                                    bookCarProvider.pickUpTimeController.text);
                                bookCarProvider.setDropTime(
                                    bookCarProvider.dropTimeController.text);

                                bookCarProvider.setEmail(emailController.text);

                                // print(
                                //     "Pick Up Time: ${_pickUpTimeController.text}");
                                // print(
                                //     "Drop Time: ${_dropTimeController.text}");

                                // pickImage();
                                bookCarProvider.updateBookCar();
                                if (bookCarProvider.isSuccess) {
                                  Helper.displaySnackBar(context,
                                      "Successfully updated the booking details.");
                                  setState(() {});
                                } else {
                                  Helper.displaySnackBar(context,
                                      "Couldn't update the booking details.");
                                }
                                // print(
                                //     "Pick Up Time: ${_pickUpTimeController.text}");
                                // print(
                                //     "Drop Time: ${_dropTimeController.text}");
                                setState(() {});
                              },
                              child:
                                  // loader == true
                                  // ? CircularProgressIndicator():
                                  Text(
                                "Change Booking Details",
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
    );
  }

  // Future<void> _selectStartDate(BuildContext context) async {
  //   NepaliDateTime? pickedDate = await showMaterialDatePicker(
  //     context: context,
  //     initialDate: _selectedStartDate!,
  //     firstDate: NepaliDateTime.now(),
  //     lastDate: NepaliDateTime(NepaliDateTime.now().year,
  //         NepaliDateTime.now().month + 1, NepaliDateTime.now().day),
  //   );

  //   if (pickedDate != null) {
  //     setState(() {
  //       _selectedStartDate = pickedDate;
  //       _startDateController.text = _formatNepaliDate(pickedDate);
  //       Provider.of<BookCarProvider>(context, listen: false)
  //           .setStartDate(_startDateController.text);
  //     });
  //   }
  // }

  Future<void> _selectStartDate(BuildContext context) async {
    NepaliDateTime? pickedDate = await showMaterialDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? NepaliDateTime.now(),
      firstDate: NepaliDateTime.now(),
      lastDate: NepaliDateTime(NepaliDateTime.now().year,
          NepaliDateTime.now().month + 1, NepaliDateTime.now().day),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
        _startDateController.text = _formatNepaliDate(pickedDate);
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
      lastDate: NepaliDateTime(_selectedStartDate!.year,
          _selectedStartDate!.month + 1, _selectedStartDate!.day),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedEndDate = pickedDate;
        _endDateController.text = _formatNepaliDate(pickedDate);
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
        _selectedPickUpTime = pickedTime;
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
        _selectedDropTime = pickedTime;
        _dropTimeController.text = pickedTime.format(context);

        // Update provider with the selected drop time
        Provider.of<BookCarProvider>(context, listen: false)
            .setDropTime(_dropTimeController.text);
      });
    }
  }

  Future<void> pickImage() async {
    setState(() {
      loader = true; // Show loader before upload
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        loader = false; // Hide loader if user cancels
      });
      return;
    }

    file = File(image.path);
    // Optionally upload the image to Firebase Storage
    // await uploadImageToFirebase(file);

    setState(() {
      loader = false; // Hide loader after upload
    });
  }

  // Optional: Function to upload the image to Firebase Storage
  Future<void> uploadImageToFirebase(File file) async {
    try {
      // Upload file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('driving_licenses/${file.path.split('/').last}');
      await storageRef.putFile(file);
      downloadUrl = await storageRef.getDownloadURL();
      // Update your provider or state with the downloadUrl if needed
    } catch (e) {
      // Handle any errors
      print("Error uploading image: $e");
    }
  }
}
