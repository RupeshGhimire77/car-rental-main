import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBookTextfield extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  CustomBookTextfield({
    Key? key,
    this.initialValue,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.inputFormatters,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 35,
        child: TextFormField(
          style: TextStyle(color: Color(0xff7B776D)),
          initialValue: initialValue,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 7),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            labelText: labelText,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(color: Color(0xffC3BEB6))),
          ),
        ),
      ),
    );
  }
}
