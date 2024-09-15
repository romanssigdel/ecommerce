import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/view/button_navbar.dart';
import 'package:ecommerce/view/description_page.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/signup_form.dart';
import 'package:ecommerce/view/splash_screen.dart';
import 'package:ecommerce/view/user_account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoginUserLoggedIn = false;
  @override
  void initState() {
    getLoginUserFromSharedPreference();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IconsProvider(),
        )
      ],
      child: MaterialApp(
        title: 'EPasal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isLoginUserLoggedIn
            ? CustomBottomNavigationBar()
            : SplashScreenPage(),
      ),
    );
  }

  getLoginUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoginUserLoggedIn = prefs.getBool("isLogin") ?? false;
    setState(() {
      isLoginUserLoggedIn;
    });
  }
}
