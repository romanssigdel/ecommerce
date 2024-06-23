import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getValue();
  }

  // getValue() {
  //   Future.delayed(
  //     Duration.zero,
  //     () {
  //       var provider = Provider.of<UserProvider>(context, listen: false);
  //       provider.loginCheckUserData();
  //     },
  //   );
  // }

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
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(
                            // width: 10,
                            ),
                        UserData.userData!.role == "user"
                            ? Text(
                                UserData.userData!.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : Text(UserData.userData!.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(
                            // width: 50,
                            ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              size: 30,
                              color: Colors.white,
                            )),
                        CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage("assets/images/logo.png")),
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
                          children: [Text("Vouchers"), Text("10")],
                        ),
                        Column(
                          children: [Text("Stores"), Text("10")],
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
                onPressed: () {
                  userProvider.deleteUserData();
                  if (userProvider.getDeleteUserStatus == StatusUtil.success) {
                    Helper.displaySnackbar(
                        context, "Data Successfully deleted");
                  } else if (userProvider.getDeleteUserStatus ==
                      StatusUtil.error) {
                    Helper.displaySnackbar(context, "Data Deletion Failed!");
                  }
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
    Helper.displaySnackbar(context, "Successfully Logged Out!");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SigninPage(),
        ),
        (route) => false);
  }
}
