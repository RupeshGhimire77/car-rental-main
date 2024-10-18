import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/utils/status_util.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<UserProvider>(
        builder: (context, userProvider, child) =>
            userProvider.getUserStatus == StatusUtil.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      userProvider.userList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: userProvider.userList.length,
                                itemBuilder: (context, index) {},
                              ),
                            )
                          : const Text("No data available")
                    ],
                  ),
      )),
    );
  }
}
