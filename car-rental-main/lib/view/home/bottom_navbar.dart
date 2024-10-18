import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/history.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/home_page.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/user_profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> widgetList = [HomePage(), History(), UserProfile()];
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
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
                icon: Icon(Icons.person_pin_circle), label: "Profile")
          ]),
    );
  }
}
