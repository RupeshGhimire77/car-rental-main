import 'package:flutter/material.dart';

class CustomBookButton extends StatelessWidget {
  CustomBookButton({super.key, required this.onPressed, required this.child});
  void Function()? onPressed;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.only(left: 0, right: 20, bottom: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff266365),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xffC3BEB6), width: 1))),
                onPressed: onPressed,
                child: child)),
      ),
    );
  }
}
