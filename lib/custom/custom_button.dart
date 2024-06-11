import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  Widget? child;
  Color? backgroundColor;
  Color? foregroundColor;
  CustomButton(
      {super.key,
      this.onPressed,
      this.child,
      this.backgroundColor,
      this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .95,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor),
            onPressed: onPressed,
            child: child));
  }
}
