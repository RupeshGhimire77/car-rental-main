import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key, required this.onPressed, required this.child});
  void Function()? onPressed;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 10),
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * .85,
            child: Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.red, width: 2))),
                    onPressed: onPressed,
                    child: child))),
      ),
    );
  }
}
