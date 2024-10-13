import 'package:ecommerce/utils/color_const.dart';
import 'package:flutter/material.dart';

class AddCart extends StatefulWidget {
  var data;
  AddCart({super.key, this.data});

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          foregroundColor: buttonForegroundColor,
          title: Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [],
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
