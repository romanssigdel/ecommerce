import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String? labelText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  CustomTextFormField(
      {super.key, this.labelText, this.prefixIcon, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
