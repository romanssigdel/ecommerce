import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/description_page_first.dart';
import 'package:ecommerce/view/description_page_second.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/signup_form.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  List<bool> isSelected = [true, false];
  int pageIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 460,
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
                      pageIndex = index;
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
              fillColor: buttonBackgroundColor,
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
                  child: Text(""),
                ),
                SizedBox(
                  child: Text(""),
                )
              ],
              isSelected: isSelected,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                pageIndex < 1
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: CustomButton(
                          backgroundColor: buttonBackgroundColor,
                          foregroundColor: buttonForegroundColor,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomBottomNavigationBar(),
                                ),
                                (route) => false);
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ))
                    : SizedBox(),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CustomButton(
                      backgroundColor: buttonBackgroundColor,
                      foregroundColor: buttonForegroundColor,
                      onPressed: () {
                        if (pageIndex < 1) {
                          pageController.nextPage(
                              duration: Duration(microseconds: 2),
                              curve: Curves.easeInOut);
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomBottomNavigationBar(),
                              ),
                              (route) => false);
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
