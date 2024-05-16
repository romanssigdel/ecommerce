import 'package:flutter/material.dart';

class DescriptionPageFirst extends StatefulWidget {
  const DescriptionPageFirst({super.key});

  @override
  State<DescriptionPageFirst> createState() => _DescriptionPageFirstState();
}

class _DescriptionPageFirstState extends State<DescriptionPageFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100.0, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/ecommerce1.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              "Easy Shopping and Great\n Finds at your Fingertips.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            )
          ],
        ),
      ),
    );
  }
}
