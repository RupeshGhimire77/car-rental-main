import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/brand.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/provider/brand_Provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/rating_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/home.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class BrandsSort extends StatefulWidget {
  final String brandName; // Accept the brand name

  const BrandsSort({required this.brandName, Key? key}) : super(key: key);

  @override
  State<BrandsSort> createState() => _BrandsSortState();
}

class _BrandsSortState extends State<BrandsSort> {
  @override
  User1? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
    getUserData();
    getCarData();
    getBrandData();
  }

  String? name, email, role;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");

      // var provider = Provider.of<CarProvider>(context, listen: false);
      // await provider.getCar();

      // setState(() {
      //   // user = User1(email: email, name: name, role: role);
      // });
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

  getBrandData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<BrandProvider>(context, listen: false);
        await provider.getBrand();
      },
    );
  }

  TextStyle normalText =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
  Color? white = Colors.white;

  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final userDetails = userProvider.getUserByEmail(email);
      return Scaffold(
        backgroundColor: Color(0xff771616),
        appBar: _appBar(),
        body: Column(
          children: [_carList()],
        ),
      );
    });
  }

  Consumer _carList() {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    return Consumer<CarProvider>(builder: (context, carProvider, child) {
      var filteredCars = carProvider.carList
          .where((car) => car.brand == widget.brandName)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: Text(
                '${widget.brandName} Cars',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          filteredCars.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "There are no available cars for this brand.",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(20),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filteredCars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                car: car,
                              ),
                            ));
                      },
                      child: Container(
                        width: widthSize * .27,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            car.image == null || car.image!.isEmpty
                                ? Container(
                                    width: widthSize,
                                    height: heightSize * .106,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/images/sedan.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : Container(
                                    // width: widthSize,
                                    // height: heightSize * .106,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        car.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Consumer<RatingProvider>(
                                  builder: (context, ratingProvider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.yellow[900],
                                            ),
                                            Text(
                                              // "(${(ratingProvider.ratingList[car.id]?.first ?? 0.0).toStringAsFixed(1)}/5) ${ratingProvider.totalNoOfRatings[car.id]?.first ?? 0}",
                                              "${(car.averageRatings!).toStringAsFixed(2)}/5" +
                                                  " (${car.totalNoOfRatings})",

                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      car.model!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rs." + car.rentalPrice! + "/Day",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.orangeAccent),
                                          child: Text(
                                            car.availableStatus!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
        ],
      );
    });
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
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: Colors.grey,
      height: 120,
      width: 180,
      alignment: Alignment.center,
      child: Text(
        'Image Error',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
