import 'package:flutter/material.dart';

class DescriptionPageSecond extends StatefulWidget {
  const DescriptionPageSecond({super.key});

  @override
  State<DescriptionPageSecond> createState() => _DescriptionPageSecondState();
}

class _DescriptionPageSecondState extends State<DescriptionPageSecond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/ecommerce2.png"),
            Text(
              "Your ultimate Shopping\n    Experience awaits.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            )
          ],
        ),
      ),
    );
    ;
  }
}
