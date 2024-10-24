import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/user1.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/utils/helper.dart';
import 'package:flutter_application_1/utils/string_const.dart';
import 'package:flutter_application_1/view/home/bottom%20nav%20bar/edit_profile.dart';
import 'package:flutter_application_1/view/home/user%20login/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        backgroundColor: Color(0xff771616),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 20),
                child: Center(
                  child: Text(
                    "User Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/images/Jackie-Chan.jpeg"),
                ),
              ),
              // if (user != null)
              Text(
                name ?? "",
                // "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                email ?? "",
                // "",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              //Edit Profile Button
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .05,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.red, width: 1))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),

              //Settings For the users (in List)
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Column(
                  children: [
                    ProfileSettingsList(
                      icon: Icons.settings,
                      onPress: () {},
                      title: "Settings",
                    ),
                    ProfileSettingsList(
                      icon: Icons.manage_accounts,
                      onPress: () {},
                      title: "User Management",
                    ),
                    ProfileSettingsList(
                      icon: Icons.contact_phone,
                      onPress: () {},
                      title: "Contact Customer Service",
                    ),
                    ProfileSettingsList(
                      icon: Icons.info_outlined,
                      onPress: () {},
                      title: "Information",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ProfileSettingsList(
                        icon: Icons.logout,
                        onPress: () {
                          logoutShowDialog(context, userProvider);
                        },
                        title: "Logout",
                        endIcon: false,
                        textColor: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLogin");
    await Helper.displaySnackBar(context, logoutSuccessfullStr);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  signOut() async {
    // FirebaseAuth.instance.signOut();
    // if (GoogleSignIn().currentUser != null) {
    //   await GoogleSignIn().signOut();
    // }

    // try {
    //   await GoogleSignIn().disconnect();
    // } catch (e) {
    //   // Helper.displaySnackBar(context, "Failed to disconnect on SignOut.");
    // }

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Login(),
    //     ),
    //     (route) => false);
  }

  logoutShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                logout();
                signOut();
                Helper.displaySnackBar(context, "Logout Successfull!");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false);

                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        // color: Colors.black,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withOpacity(0.1)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18)
            ?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              // color: Colors.black,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
              ),
            )
          : null,
    );
  }
}
