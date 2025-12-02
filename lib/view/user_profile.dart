import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/AboutShopizoPage.dart';
import 'package:ecommerce/view/admin_function.dart';
import 'package:ecommerce/view/contact_customer_service.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/edit_user.dart';
import 'package:ecommerce/view/reset_password.dart';
import 'package:ecommerce/view/user_setttings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // User1? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getValue();
    getUserId();
    initializeUserData();
  }

  String? uId, userRole;
  // getUserRole(String uId) async {
  //   var provider = Provider.of<AuthenticationProvider>(context, listen: false);
  //   userRole = await provider.getUserRole(uId);
  //   return userRole;
  // }

  Future<String?> getUserId() async {
    var provider = Provider.of<AuthenticationProvider>(context, listen: false);
    uId = provider.currentUser!.uid;
    return uId;
  }

  void initializeUserData() async {
    var provider = Provider.of<AuthenticationProvider>(context, listen: false);

    uId = provider.currentUser?.uid;

    if (uId != null) {
      userRole = await provider.getUserRole(uId!);
      setState(() {}); // Refresh UI after data is fetched
    }
  }

  String? id, name, email, role, password;

  getValue() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString("userId");
      name = prefs.getString("userName");
      email = prefs.getString("userEmail");
      password = prefs.getString("userPassword");
      role = prefs.getString("userRole");
      setState(() {
        id;
        name;
        email;
        role;
        password;
      });
      // setState(() {
      //   user = User(email: email, name: name, role: role);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) => Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 45, bottom: 20),
              //   child: Center(
              //     child: Text(
              //       "User Profile",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: authProvider.currentUser?.photoURL != null
                      ? NetworkImage(authProvider.currentUser!.photoURL!)
                      : AssetImage("assets/images/user.png") as ImageProvider,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // if (user != null)
              Text(
                authProvider.currentUser!.displayName ?? "",
                // "",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                authProvider.currentUser!.email ?? "",
                // "",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),

              //Edit Profile Button
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * .5,
              //     height: MediaQuery.of(context).size.height * .05,
              //     child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.black,
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 side: BorderSide(
              //                     color: Color.fromARGB(255, 3, 8, 20),
              //                     width: 1))),
              //         onPressed: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => EditUserData(
              //                   id: authProvider.currentUser!.uid,
              //                   name: authProvider.currentUser!.displayName,
              //                   email: authProvider.currentUser!.email,
              //                 ),
              //               ));
              //         },
              //         child: Text(
              //           "Edit Profile",
              //           style: TextStyle(color: Colors.white, fontSize: 18),
              //         )),
              //   ),
              // ),

              //Settings For the users (in List)
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Column(
                  children: [
                    userRole == "admin"
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: ProfileSettingsList(
                              icon: Icons.admin_panel_settings_rounded,
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminFunctions(
                                        uId: uId,
                                        userRole: userRole,
                                      ),
                                    ));
                              },
                              title: "Admin Functions",
                            ),
                          )
                        : SizedBox(),
                    // ProfileSettingsList(
                    //   icon: Icons.settings,
                    //   onPress: () {},
                    //   title: "Settings",
                    // ),
                    // SizedBox(height: 10),
                    ProfileSettingsList(
                      icon: Icons.manage_accounts,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSettings(),
                            ));
                      },
                      title: "User Management",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileSettingsList(
                      icon: Icons.contact_phone,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactCustomerServicePage(),
                            ));
                      },
                      title: "Contact Customer Service",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ProfileSettingsList(
                      icon: Icons.info_outlined,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutShopizoPage(),
                            ));
                      },
                      title: "Information",
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ProfileSettingsList(
                        icon: Icons.logout,
                        onPress: () {
                          logoutShowDialog(context, authProvider);
                        },
                        title: "Logout",
                        endIcon: false,
                        textColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // // logout() async {
  // //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  // //   await prefs.remove("isLogin");
  // //   await Helper.displaySnackbar(context, "Logout Successfull!");

  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CustomBottomNavigationBar(),
  //       ),
  //       (route) => false);
  // }

  signOut() async {
    FirebaseAuth.instance.signOut();
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().signOut();
    }

    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      // Helper.displaySnackBar(context, "Failed to disconnect on SignOut.");
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CustomBottomNavigationBar(),
        ),
        (route) => false);
  }

  logoutShowDialog(BuildContext context, AuthenticationProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                // logout();
                signOut();
                Helper.displaySnackbar(context, "Logout Successfull!");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomBottomNavigationBar(),
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

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        // color: Colors.black,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withOpacity(0.1)),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 18)
            .apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              // color: Colors.black,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
              ),
            )
          : null,
    );
  }
}
