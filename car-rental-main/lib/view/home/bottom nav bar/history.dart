import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/book_car_provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getValue();
    getUserData();
    getCarData();
    getBookData();
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

  getUserData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<UserProvider>(context, listen: false);
        await provider.getUser();
      },
    );
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

  getBookData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<BookCarProvider>(context, listen: false);
        await provider.getBookCar();
      },
    );
  }

  Widget build(BuildContext context) {
    final userEmail = email ?? '';
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
            name ?? "",
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
      body: Consumer2<CarProvider, BookCarProvider>(
          builder: (context, carProvider, bookCarProvider, child) {
        final userBookings = bookCarProvider.getUserBookings(userEmail);
        if (userBookings.isEmpty) {
          return Center(
            child: Text(
              "You have yet to rent any car.",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }

        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userBookings.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final booking = userBookings[index];
                  final carDetails = carProvider.getCarById(booking.carId);

                  if (carDetails == null) {
                    return Center(
                      child: Text(
                        "Car details not available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Center(
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * .9,
                      child: Card(
                        child: Column(
                          children: [
                            _buildCarCard(context, carDetails),
                            // Text(
                            //     "Rental Price: ${carDetails?.rentalPrice ?? 'N/A'}"),
                            Text("Pick-up Location: ${booking.pickUpPoint}"),
                            Text("Start Date: ${booking.startDate}"),
                            Text("End Date: ${booking.endDate}"),
                            Text("Pick-up Time: ${booking.pickUpTime}"),
                            Text("Drop Time: ${booking.dropTime}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildCarCard(BuildContext context, Car car) {
    return SizedBox(
      height: 300,
      width: 300,
      child: GestureDetector(
        onTap: () async {
          // await carProvider.getCarDetails();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DescriptionPage(
                  car: car,
                ),
              ));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              car.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(10),
                          topStart: Radius.circular(10)),
                      child: FadeInImage(
                        placeholder: AssetImage(
                            'assets/images/placeholder.png'), // Use an asset image placeholder or use `Shimmer` widget here
                        image: NetworkImage(car.image!),
                        height: 120,
                        width: 180,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Shimmer.fromColors(
                            baseColor: Colors.red,
                            highlightColor: Colors.yellow,
                            child: Container(
                              color: Colors.grey,
                              height: 120,
                              width: 180,
                              alignment: Alignment.center,
                              child: Text(
                                'Image Error',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        placeholderErrorBuilder: (context, error, stackTrace) {
                          return Shimmer.fromColors(
                            baseColor: Colors.deepPurple[300]!,
                            highlightColor: Colors.deepPurple[100]!,
                            child: Container(
                              color: Colors.white,
                              height: 120,
                              width: 180,
                              alignment: Alignment.center,
                            ),
                          );
                        },
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.red,
                      highlightColor: Colors.yellow,
                      child: Container(
                        height: 120,
                        width: 180,
                        alignment: Alignment.center,
                        child: Text(
                          'Shimmer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(car.model!),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("" + car.brand! + ""),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Rs. " + car.rentalPrice! + "/day"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: Colors.grey,
      alignment: Alignment.center,
      child: Text(
        'No Image',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
