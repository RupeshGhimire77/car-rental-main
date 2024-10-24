import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/brand.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/provider/brand_Provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
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

  Widget build(BuildContext context) {
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
        body: Consumer<CarProvider>(
          builder: (context, carProvider, child) {
            // Filter cars by the selected brand name
            var filteredCars = carProvider.carList
                .where((car) => car.brand == widget.brandName)
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: Text(
                    "${widget.brandName} Cars", // Show the selected brand name
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: filteredCars.isEmpty
                        ? Text(
                            "There are no cars available for this Brand.",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 1,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              children: List.generate(
                                filteredCars
                                    .length, // Use the filtered car list
                                (index) {
                                  return SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(
                                              car: filteredCars[
                                                  index], // Pass the filtered car
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            filteredCars[index].image != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: FadeInImage(
                                                      placeholder: AssetImage(
                                                          'assets/images/placeholder.png'),
                                                      image: NetworkImage(
                                                          filteredCars[index]
                                                              .image!),
                                                      height: 120,
                                                      width: 180,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return _buildImageErrorPlaceholder();
                                                      },
                                                    ),
                                                  )
                                                : _buildImageErrorPlaceholder(),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  filteredCars[index].model!),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  "Rs. ${filteredCars[index].rentalPrice!}/day"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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
