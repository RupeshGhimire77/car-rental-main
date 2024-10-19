import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/provider/brand_Provider.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/description_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    // List<Brand> brandList = [
    //   Brand(brandImg: "assets/images/redcar1.png", brandName: "BMW"),
    //   Brand(
    //       brandImg: "assets/images/redcar1.png",
    //       brandName: "Lamborghini Avantador"),
    //   Brand(brandImg: "assets/images/redcar1.png", brandName: "Audi"),
    //   Brand(brandImg: "assets/images/redcar1.png", brandName: "TATA"),
    //   Brand(
    //       brandImg: "assets/images/redcar1.png",
    //       brandName: "Lamborghini Avantador"),
    //   Brand(brandImg: "assets/images/redcar1.png", brandName: "Audi"),
    // ];

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
          body: SingleChildScrollView(
            child: Consumer<CarProvider>(
              builder: (context, carProvider, child) => carProvider
                          .getCarStatus ==
                      StatusUtil.loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          12), // Padding inside the search bar
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                        .8), // Background color for the search bar
                                    borderRadius: BorderRadius.circular(
                                        30), // Rounded corners
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search...", // Placeholder text
                                      border:
                                          InputBorder.none, // Remove underline
                                      icon: Icon(Icons.search), // Search icon
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(.1)),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      size: 35,
                                      Icons.filter_list,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              color: Colors.brown[900]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 5),
                                    child: Text(
                                      "Brands",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
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
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 1,
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      children: List.generate(
                                        carProvider.carList.length,
                                        (index) {
                                          return SizedBox(
                                            height: 300,
                                            width: 300,
                                            child: GestureDetector(
                                              onTap: () async {
                                                // await carProvider.getCarDetails();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DescriptionPage(
                                                        car: carProvider
                                                            .carList[index],
                                                      ),
                                                    ));
                                              },
                                              child: Card(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    carProvider.carList[index]
                                                                .image !=
                                                            null
                                                        ? ClipRRect(
                                                            borderRadius: BorderRadiusDirectional.only(
                                                                topEnd: Radius
                                                                    .circular(
                                                                        10),
                                                                topStart: Radius
                                                                    .circular(
                                                                        10)),
                                                            child: FadeInImage(
                                                              placeholder:
                                                                  AssetImage(
                                                                      'assets/images/placeholder.png'), // Use an asset image placeholder or use `Shimmer` widget here
                                                              image: NetworkImage(
                                                                  carProvider
                                                                      .carList[
                                                                          index]
                                                                      .image!),
                                                              height: 120,
                                                              width: 177,
                                                              fit: BoxFit.cover,
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Shimmer
                                                                    .fromColors(
                                                                  baseColor:
                                                                      Colors
                                                                          .red,
                                                                  highlightColor:
                                                                      Colors
                                                                          .yellow,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .grey,
                                                                    height: 120,
                                                                    width: 177,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      'Image Error',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20.0,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              placeholderErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Shimmer
                                                                    .fromColors(
                                                                  baseColor:
                                                                      Colors.deepPurple[
                                                                          300]!,
                                                                  highlightColor:
                                                                      Colors.deepPurple[
                                                                          100]!,
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .white,
                                                                    height: 120,
                                                                    width: 177,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Shimmer.fromColors(
                                                            baseColor:
                                                                Colors.red,
                                                            highlightColor:
                                                                Colors.yellow,
                                                            child: Container(
                                                              height: 120,
                                                              width: 177,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                'Shimmer',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      40.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(height: 5),
                                                    Text(carProvider
                                                        .carList[index].model!),
                                                    Text(carProvider
                                                        .carList[index]
                                                        .rentalPrice!)
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
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          )),
    );
  }

  // Widget _buildBrandListUI() {
  //   return Padding(
  //       padding: const EdgeInsets.only(right: 12),
  //       child:
  //           Consumer<BrandProvider>(builder: (context, brandProvider, child) {
  //         return SizedBox(
  //           height: 155,
  //           child: ListView.builder(
  //             itemCount: brandProvider.brandList.length,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(left: 10, top: 10),
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.height * 0.12,
  //                   width: MediaQuery.of(context).size.width * 0.4,
  //                   decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.black),
  //                       borderRadius: BorderRadius.circular(20),
  //                       color: Colors.white.withOpacity(0.1)),
  //                   child: Column(children: [
  //                     SizedBox(
  //                       height: MediaQuery.of(context).size.height * 0.11,
  //                       width: MediaQuery.of(context).size.width * 0.4,
  //                       child: Card(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             brandProvider.brandList[index].brandImage != null
  //                                 ? ClipRRect(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     child: FadeInImage(
  //                                       placeholder: AssetImage(
  //                                           'assets/images/placeholder.png'),
  //                                       image: NetworkImage(brandProvider
  //                                           .brandList[index].brandImage!),
  //                                       height:
  //                                           MediaQuery.of(context).size.height *
  //                                               0.190,
  //                                       width:
  //                                           MediaQuery.of(context).size.width *
  //                                               0.5,
  //                                       fit: BoxFit.cover,
  //                                       imageErrorBuilder:
  //                                           (context, error, stackTrace) {
  //                                         return _buildImageErrorPlaceholder();
  //                                       },
  //                                     ),
  //                                   )
  //                                 : _buildImageErrorPlaceholder()
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         // brandList[index].brandName!,
  //                         brandProvider.brandList[index].brandName!,
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     )
  //                   ]),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       }));
  // }

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

// class Brand {
//   String? brandImg, brandName;
//   Brand({this.brandImg, this.brandName});
// }
