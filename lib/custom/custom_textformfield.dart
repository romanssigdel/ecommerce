import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String? labelText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  bool obscureText;
  CustomTextFormField(
      {super.key,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.validator,
      this.keyboardType,
      this.obscureText = false,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        validator: validator,
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
