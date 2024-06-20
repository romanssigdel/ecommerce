import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    getValue();
  }

  getValue() {
    Future.delayed(
      Duration.zero,
      () {
        var provider = Provider.of<UserProvider>(context, listen: false);
        provider.loginCheckUserData();
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
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        userProvider.userData!.role == "user"
                            ? Text(
                                userProvider.userData!.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            : Text(userProvider.userData!.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(
                          width: 50,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
