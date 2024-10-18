import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/admin/admin_dashboard.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/home_page.dart';

class AdminBottomNavBar extends StatefulWidget {
  final int initialIndex;
  AdminBottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  List<Widget> widgetList = [
    // ProductPage(),
    HomePage(),
    AdminDashboard(),
  ];
  int selectIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectIndex = widget.initialIndex;
  }

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
            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits),
                label: "Products"),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
          ]),
    );
  }
}
