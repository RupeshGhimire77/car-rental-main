import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/car.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/provider/brand_Provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/rating_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/brands_sort.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double averageRating = 0.0;
  int numberOfRatings = 0;
  User1? user;
  Car? car;
  List<Car> filteredCars = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getValue();
    getUserData();
    getCarData();
    getBrandData();
    // filteredCars = Provider.of<CarProvider>(context, listen: false).carList;
  }

  // Future<void> _fetchCarRating(String carId) async {
  //   final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
  //   Map<String, dynamic> ratingDetails =
  //       await ratingProvider.getCarRatingDetails(carId);

  //   setState(() {
  //     averageRating = ratingDetails['averageRating'];
  //     numberOfRatings = ratingDetails['numberOfRatings'];
  //   });
  // }

  // void _onCarSelected(Car car) {
  //   // Call the fetch function with the selected car's ID
  //   _fetchCarRating(car.id!);
  // }

  String? name, email, role;

  // void _filteredCars(String query) {
  //   final carProvider = Provider.of<CarProvider>(context, listen: false);
  //   List<Car> results = [];

  //   if (query.isEmpty) {
  //     results = carProvider.carList;
  //   } else {
  //     results = carProvider.carList
  //         .where(
  //             (car) => car.model!.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     filteredCars = results;
  //   });
  // }

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

      if (results.isNotEmpty) {
        // Save the brand of the first matching car to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastSearchedBrand', results.first.brand ?? '');
      }
    }
    setState(() {
      filteredCars = results;
    });
  }

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

  // getCarData() async {
  //   Future.delayed(
  //     Duration.zero,
  //     () async {
  //       var provider = Provider.of<CarProvider>(context, listen: false);
  //       await provider.getCar();

  //       setState(() {
  //         filteredCars = provider.carList;
  //       });
  //     },
  //   );
  // }

  // getCarData() async {
  //   Future.delayed(
  //     Duration.zero,
  //     () async {
  //       final prefs = await SharedPreferences.getInstance();
  //       final lastSearchedBrand = prefs.getString('lastSearchedBrand');

  //       var provider = Provider.of<CarProvider>(context, listen: false);
  //       await provider.getCar();

  //       // Prioritize cars with the last-searched brand
  //       List<Car> sortedCars = provider.carList;
  //       if (lastSearchedBrand != null && lastSearchedBrand.isNotEmpty) {
  //         sortedCars.sort((a, b) {
  //           if (a.brand == lastSearchedBrand && b.brand != lastSearchedBrand) {
  //             return -1;
  //           } else if (a.brand != lastSearchedBrand &&
  //               b.brand == lastSearchedBrand) {
  //             return 1;
  //           }
  //           return 0;
  //         });
  //       }

  //       setState(() {
  //         filteredCars = sortedCars;
  //       });
  //     },
  //   );
  // }
  getCarData() async {
    Future.delayed(
      Duration.zero,
      () async {
        final prefs = await SharedPreferences.getInstance();
        final lastSearchedBrand = prefs.getString('lastSearchedBrand');

        var carProvider = Provider.of<CarProvider>(context, listen: false);
        var ratingProvider =
            Provider.of<RatingProvider>(context, listen: false);

        await carProvider.getCar();

        // Prioritize cars with the last-searched brand
        List<Car> sortedCars = carProvider.carList;
        if (lastSearchedBrand != null && lastSearchedBrand.isNotEmpty) {
          sortedCars.sort((a, b) {
            if (a.brand == lastSearchedBrand && b.brand != lastSearchedBrand) {
              return -1;
            } else if (a.brand != lastSearchedBrand &&
                b.brand == lastSearchedBrand) {
              return 1;
            }
            return 0;
          });
        }

        // Sort cars based on ratings using Bubble Sort
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
        double ratingA = ratingProvider.ratingList[cars[j].id]?.first ?? 0.0;
        double ratingB =
            ratingProvider.ratingList[cars[j + 1].id]?.first ?? 0.0;

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

  getBrandData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<BrandProvider>(context, listen: false);
        await provider.getBrand();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User1? user;

    // Get the current user
    // User? user1 = FirebaseAuth.instance.currentUser;

    // Fallback to email if displayName is null
    // String displayName = user1?.displayName ?? user1?.email ?? "User";

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          body: Consumer2<CarProvider, RatingProvider>(
            builder: (context, carProvider, ratingProvider, child) =>
                carProvider.getCarStatus == StatusUtil.loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              height: MediaQuery.of(context).size.width * .4,
                              child: ClipRect(
                                child: Image.asset(
                                  "assets/images/redcar1.png",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Search...",
                                        border: InputBorder.none,
                                        icon: Icon(Icons.search),
                                      ),
                                      onChanged: _filteredCars,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              color: Colors.brown[900],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 5),
                                  child: Text(
                                    "Brands",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildBrandListUI(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 20),
                                  child: Text(
                                    "Cars",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 1,
                                    ),
                                    itemCount: filteredCars.length,
                                    itemBuilder: (context, index) {
                                      return _buildCarCard(context,
                                          filteredCars[index], ratingProvider);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
          )),
    );
  }
}

Widget _buildBrandListUI() {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Consumer<BrandProvider>(builder: (context, brandProvider, child) {
      return SizedBox(
        height: 155, // Fixed height for horizontal scrolling
        child: ListView.builder(
          itemCount: brandProvider.brandList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    // Image Container
                    SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: GestureDetector(
                        onTap: () {
                          String selectedBrand = brandProvider.brandList[index]
                              .brandName!; // Get the selected brand name

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrandsSort(
                                  brandName:
                                      selectedBrand), // Pass the selected brand
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              brandProvider.brandList[index].brandImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/placeholder.png'),
                                        image: NetworkImage(brandProvider
                                            .brandList[index].brandImage!),
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.125, // Adjusted to fit within container
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return _buildImageErrorPlaceholder();
                                        },
                                      ),
                                    )
                                  : _buildImageErrorPlaceholder()
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Brand Name
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        brandProvider.brandList[index].brandName!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }),
  );
}

Widget _buildCarCard(
    BuildContext context, Car car, RatingProvider ratingProvider) {
  ratingProvider.calculateAverageRating(car.id!);
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
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.yellow[900],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      "(${(ratingProvider.ratingList[car.id]?.first ?? 0.0).toStringAsFixed(1)}/5) ${ratingProvider.totalNoOfRatings[car.id]?.first ?? 0}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(car.model!),
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
