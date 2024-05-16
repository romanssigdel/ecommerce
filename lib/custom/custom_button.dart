import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  Widget? child;
  CustomButton({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .95,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff1161FC)),
            onPressed: onPressed,
            child: child));
  }
}
