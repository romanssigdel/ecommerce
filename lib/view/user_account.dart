import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  getValue() {
    Future.delayed(
      Duration.zero,
      () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userName = prefs.getString("userName");
        String? userEmail = prefs.getString("userEmail");
        String? userRole = prefs.getString("userRole");
        setState(() {
          user = User(email: userEmail, name: userName, role: userRole);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                color: buttonBackgroundColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            if (user != null)
                              Text(
                                user!.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.settings,
                                  size: 30,
                                  color: Colors.white,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("assets/images/logo.png")),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "My WishList",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "10",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("Vouchers",
                                style: TextStyle(color: Colors.white)),
                            Text("10", style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          children: [
                            Text("Stores",
                                style: TextStyle(color: Colors.white)),
                            Text("10", style: TextStyle(color: Colors.white))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              CustomButton(
                onPressed: () {
                  logoutUserFromSharedPreference();
                },
                child: Text("Logout"),
              ),
              CustomButton(
                onPressed: () async {
                  createShowDialog(context, userProvider);
                },
                child: userProvider.getDeleteUserStatus == StatusUtil.loading
                    ? CircularProgressIndicator()
                    : Text("Delete"),
              )
            ],
          ),
        ),
      ),
    );
  }

  logoutUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    Helper.displaySnackbar(context, "Successfully Logged Out!");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SigninPage(),
        ),
        (route) => false);
  }

  createShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete File'),
          content: Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () async {
                await userProvider.deleteUserData();
                if (userProvider.getDeleteUserStatus == StatusUtil.success) {
                  Helper.displaySnackbar(context, "Data Successfully deleted");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SigninPage(),
                      ),
                      (route) => false);
                }
                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
