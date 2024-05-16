import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/description_page_first.dart';
import 'package:ecommerce/description_page_second.dart';
import 'package:ecommerce/signin_form.dart';
import 'package:ecommerce/signup_form.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  List<bool> isSelected = [true, false];
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 170,
          ),
          Expanded(
              child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              for (int i = 0; i < isSelected.length; i++) {
                if (i == index) {
                  isSelected[i] = true;
                } else {
                  isSelected[i] = false;
                }
                setState(() {
                  isSelected;
                  if (index == 1) {
                    pageController.nextPage(
                        duration: Duration(microseconds: 2),
                        curve: Curves.easeInOut);
                  } else {
                    pageController.previousPage(
                        duration: Duration(microseconds: 2),
                        curve: Curves.easeInOut);
                  }
                });
              }
            },
            children: [DescriptionPageFirst(), DescriptionPageSecond()],
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
            child: ToggleButtons(
              fillColor: Color(0xff1161FC),
              onPressed: (index) {
                for (int i = 0; i < isSelected.length; i++) {
                  if (i == index) {
                    isSelected[i] = true;
                  } else {
                    isSelected[i] = false;
                  }
                }
                setState(() {
                  isSelected;
                  if (index == 1) {
                    pageController.nextPage(
                        duration: Duration(microseconds: 2),
                        curve: Curves.easeInOut);
                  } else {
                    pageController.previousPage(
                        duration: Duration(microseconds: 2),
                        curve: Curves.easeInOut);
                  }
                });
              },
              children: [
                SizedBox(
                  child: Center(
                    child: Text(""),
                  ),
                ),
                SizedBox(
                  child: Center(
                    child: Text(""),
                  ),
                )
              ],
              isSelected: isSelected,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Row(
            children: [CustomButton(), CustomButton()],
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
