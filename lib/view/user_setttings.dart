import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/view/delete_account.dart';
import 'package:ecommerce/view/update_password.dart';
import 'package:ecommerce/view/update_username.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/view/edit_user.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  // User1? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) => Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Settings For the users (in List)
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Column(
                  children: [
                    ProfileSettingsList(
                      icon: Icons.person,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateUsername(),
                            ));
                      },
                      title: "Update Username",
                    ),
                    ProfileSettingsList(
                      icon: Icons.lock,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePassword(),
                            ));
                      },
                      title: "Update Password",
                    ),
                    ProfileSettingsList(
                      icon: Icons.delete,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAccount(),
                            ));
                      },
                      title: "Delete Account",
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
