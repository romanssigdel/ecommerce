import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/cart.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/my_wishlist.dart';
import 'package:ecommerce/view/user_account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  CustomBottomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<Widget> itemList = [
    HomePage(),
    MyWishlist(),
    AddCart(),
    UserAccount(),
  ];
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: itemList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: backGroundColor,
          unselectedItemColor: Colors.grey,
          // showUnselectedLabels: true,
          onTap: (value) {
            selectedIndex = value;
            setState(() {
              selectedIndex;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "My WishList"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}
