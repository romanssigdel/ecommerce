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
    //admin page starts from here
    return user!.role == "admin"
        ? Consumer<UserProvider>(
            builder: (context, userProvider, child) => SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: backGroundColor,
                      title: Text(
                        user!.name!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      leading: Builder(
                        builder: (context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ));
                        },
                      ),
                      actions: [
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
                                      AssetImage("assets/images/user.png")),
                            ),
                          ],
                        )
                      ],
                    ),
                    drawer: Drawer(
                      child: Text(
                        "hello",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    body: Column(
                      children: [
                        Container(
                          color: backGroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                        ),
                        CustomButton(
                          onPressed: () {
                            logoutShowDialog(context, userProvider);
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    ),
                  ),
                ))
        //userPage starts from here
        : Consumer<UserProvider>(
            builder: (context, userProvider, child) => SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: backGroundColor,
                  title: Text(
                    user!.name!,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ));
                    },
                  ),
                  actions: [
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
                                  AssetImage("assets/images/user.png")),
                        ),
                      ],
                    )
                  ],
                ),
                drawer: Drawer(
                  child: Text(
                    "hello",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      color: buttonBackgroundColor,
                      child: Column(
                        children: [
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
                                  Text("10",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Stores",
                                      style: TextStyle(color: Colors.white)),
                                  Text("10",
                                      style: TextStyle(color: Colors.white))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "My Orders",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("View All",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        "assets/images/package_box_alt.png"),
                                    Text("To Pay")
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/package.png"),
                                  Text("To Ship")
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/package_car.png"),
                                  Text("To Receive")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Chat_alt_3.png"),
                                    Text("Chat")
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                    "assets/images/Refund_back_light.png"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("My Returns"),
                                Spacer(),
                                Image.asset(
                                    "assets/images/package_cancellation.png"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("My Cancellations")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "My Services",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("View All",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Message.png"),
                                    Text("Messages")
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/Credit_card.png"),
                                  Text("Payment")
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/Question.png"),
                                  Text("Help")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Send_fill.png"),
                                    Text("To Review")
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Location Tracker of Products Arrival",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "Country: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Nepal",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "City: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Bhaktapur",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "Exact Location: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Sanotimi",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Arrival Time: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "0days, 3hrs",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        logoutShowDialog(context, userProvider);
                      },
                      child: Text("Logout"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () async {
                        createShowDialog(context, userProvider);
                      },
                      child:
                          userProvider.getDeleteUserStatus == StatusUtil.loading
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

  logoutShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                logoutUserFromSharedPreference();
                Helper.displaySnackbar(context, "Logout Successfull!");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SigninPage(),
                    ),
                    (route) => false);

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
