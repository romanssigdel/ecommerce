import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String? labelText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  bool obscureText;
  String? initialValue;
  TextEditingController? controller;
  bool readOnly;
  CustomTextFormField({
    super.key,
    this.labelText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.obscureText = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialValue,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(13),
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
