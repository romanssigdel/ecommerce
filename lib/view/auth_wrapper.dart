import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/services/auth_services.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/splash_screen.dart';
import 'package:ecommerce/view/user_account.dart';
import 'package:ecommerce/view/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) => StreamBuilder<User?>(
                  stream: authProvider.authStateChanges,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return CustomBottomNavigationBar();
                    }
                    return SplashScreenPage();
                  },
                )),
      ),
    );
  }
}
