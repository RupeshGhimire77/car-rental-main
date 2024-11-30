import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/provider/brand_Provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/rating_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/brands_sort.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Car> filteredCars = [];
  @override
  void initState() {
    super.initState();

    getValue();
    getUserData();
    getBrandData();
    getCarData();
  }

  String? name, email, role;
  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");
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

  getBrandData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<BrandProvider>(context, listen: false);
        await provider.getBrand();
      },
    );
  }

  void _filteredCars(String query) async {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    List<Car> results = [];

    if (query.isEmpty) {
      results = carProvider.carList;
    } else {
      results = carProvider.carList
          .where(
              (car) => car.model!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredCars = results;
    });
  }

  getCarData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var carProvider = Provider.of<CarProvider>(context, listen: false);
        var ratingProvider =
            Provider.of<RatingProvider>(context, listen: false);

        await carProvider.getCar();

        // Sort cars based on ratings using Bubble Sort
        List<Car> sortedCars = carProvider.carList;
        bubbleSortCarsByRating(sortedCars, ratingProvider);

        setState(() {
          filteredCars = sortedCars;
        });
      },
    );
  }

  void bubbleSortCarsByRating(List<Car> cars, RatingProvider ratingProvider) {
    int n = cars.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Get the average ratings for the cars
        // double ratingA = ratingProvider.ratingList[cars[j].id]?.first ?? 0.0;
        double ratingA = cars[j].averageRatings!;
        double ratingB = cars[j + 1].averageRatings!;

        // double ratingB = ratingProvider.ratingList[cars[j + 1].id]?.first ?? 0.0;

        // Swap if the car at j has a lower rating than the car at j+1
        if (ratingA < ratingB) {
          // Swap cars
          Car temp = cars[j];
          cars[j] = cars[j + 1];
          cars[j + 1] = temp;
        }
      }
    }
  }

  TextStyle normalText =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
  Color? white = Colors.white;
  Color? backGroundColor = Color(0xff771616);

  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff771616),
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: widthSize,
              height: heightSize * .15,
              child: Image.asset(
                "assets/images/redcar1.png",
                fit: BoxFit.contain,
              ),
            ),
            _searchField(),
            SizedBox(
              height: 15,
            ),
            Container(
                // height: heightSize,
                width: widthSize,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.brown[900]),
                child: Column(
                  // scrollDirection: Axis.vertical,
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  children: [
                    _brandList(),
                    SizedBox(
                      height: 15,
                    ),
                    _carList()
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Consumer _brandList() {
    final double widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    return Consumer<BrandProvider>(builder: (context, brandProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Brands',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: heightSize * .145,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemCount: brandProvider.brandList.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: 25,
              ),
              itemBuilder: (context, index) {
                final brand = brandProvider.brandList[index];
                return GestureDetector(
                  onTap: () {
                    final selectedBrand = brand.brandName;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BrandsSort(brandName: selectedBrand!),
                        ));
                  },
                  child: Container(
                    width: widthSize * .27,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        brand.brandImage != null || brand.brandImage!.isNotEmpty
                            ? Container(
                                width: widthSize,
                                height: heightSize * .106,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  brand.brandImage!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Container(
                                width: widthSize,
                                height: heightSize * .106,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  "assets/images/background.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                        Spacer(),
                        Expanded(
                          child: Text(
                            // categories[index].name,
                            brandProvider.brandList[index].brandName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }

  Consumer _carList() {
    final widthSize = MediaQuery.of(context).size.width;
    final heightSize = MediaQuery.of(context).size.height;
    return Consumer<CarProvider>(builder: (context, carProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Cars',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          GridView.builder(
            padding: EdgeInsets.all(20),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: filteredCars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
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
                      color: white, borderRadius: BorderRadius.circular(16)),
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
                        padding: const EdgeInsets.only(left: 10, right: 10),
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
                                        borderRadius: BorderRadius.circular(5),
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
            color: white,
          ),
        )
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1d1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        onChanged: _filteredCars,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: "Search...",
            hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Container(
              width: 100,
              child: const IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 0.1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.filter_list),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
