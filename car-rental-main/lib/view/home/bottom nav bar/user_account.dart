import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => UserAccountState();
}

class UserAccountState extends State<UserAccount> {
  User1? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  String? name, email, role;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name");
      email = prefs.getString("email");
      role = prefs.getString("role");

      setState(() {
        user = User1(email: email, name: name, role: role);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
