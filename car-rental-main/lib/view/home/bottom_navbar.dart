import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/history.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/home.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/home_page.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/brands_sort.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/user_profile.dart';
import 'package:flutter_application_1/view/home/user%20login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool? isLogin = false;

  getSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoginStatus = prefs.getBool("isLogin");
    setState(() {
      isLogin = isLoginStatus ?? false;
    });
  }

  List<Widget> getItemList() {
    return [
      Home(),
      History(),
      UserProfile(),
      // HomePage()
      // isLogin == true ? HomePage() : HomePage(),
    ];
  }

  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getItemList()[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              selectIndex = value;
            });
          },
          currentIndex: selectIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "History"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_circle), label: "Profile"),
            // BottomNavigationBarItem(icon: Icon(Icons.home), label: "home")
          ]),
    );
  }
}
