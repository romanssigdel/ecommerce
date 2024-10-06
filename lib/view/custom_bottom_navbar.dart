import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/cart.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/my_wishlist.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/user_account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  CustomBottomNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  bool? isLogin = false;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.initialIndex;
    getSharedPreference();
  }

  getSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoginStatus = prefs.getBool("isLogin");
    setState(() {
      isLogin = isLoginStatus ?? false;
    });
  }

  // List<Widget> itemList = [
  //   HomePage(),
  //   MyWishlist(),
  //   AddCart(),
  //   isLogin == true ? UserAccount() : SigninPage()
  // ];
  List<Widget> getItemList() {
    return [
      HomePage(),
      MyWishlist(),
      AddCart(),
      isLogin == true ? UserAccount() : SigninPage(), // Conditional logic
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getItemList()[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: backGroundColor,
          unselectedItemColor: Colors.grey,
          // showUnselectedLabels: true,
          // showSelectedLabels: false,
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
