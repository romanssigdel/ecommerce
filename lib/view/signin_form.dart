import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:ecommerce/view/signup_form.dart';
import 'package:ecommerce/view/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  RegExp regExp = RegExp(emailPattern);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        var provider = Provider.of<UserProvider>(context, listen: false);
        provider.readRememberMe();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Consumer<IconsProvider>(
                    builder: (context, iconsProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 0),
                          child: Text(
                            loginAccountStr,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          controller: userProvider.emailTextField,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return emailValidtionStr;
                            } else if (!regExp.hasMatch(value)) {
                              return emailRegexValidation;
                            }
                            return null;
                          },
                          labelText: emailStr,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                            obscureText:
                                iconsProvider.showPassword ? false : true,
                            controller: userProvider.passwordTextField,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return passwordValidationStr;
                              } else if (value.length < 8) {
                                return passwordLengthValidationStr;
                              }
                              return null;
                            },
                            labelText: passwordStr,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 30,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  iconsProvider.setShowPassword();
                                },
                                icon: iconsProvider.showPassword
                                    ? Icon(
                                        Icons.visibility,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        size: 30,
                                      ))),
                        Row(
                          children: [
                            Checkbox(
                              value: userProvider.isCheckRememberMe,
                              onChanged: (value) {
                                userProvider.rememberMe(value!);
                                userProvider.setSaveCheckRememberMe(value);
                              },
                            ),
                            Text(
                              rememberMeStr,
                            )
                          ],
                        ),
                        CustomButton(
                          backgroundColor: buttonBackgroundColor,
                          foregroundColor: buttonForegroundColor,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await userProvider.loginCheckUserData();
                              if (userProvider.getLoginUserStatus ==
                                  StatusUtil.success) {
                                if (userProvider.isUserExists) {
                                  Helper.displaySnackbar(
                                      context, loginSuccessful);
                                  userProvider
                                      .saveLoginUserToSharedPreference();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomBottomNavigationBar(),
                                      ),
                                      (route) => false);
                                } else {
                                  Helper.displaySnackbar(
                                      context, invalidCredential);
                                }
                              } else if (userProvider.getLoginUserStatus ==
                                  StatusUtil.error) {
                                Helper.displaySnackbar(context, loginFailed);
                              }
                            }
                          },
                          child: userProvider.getLoginUserStatus ==
                                  StatusUtil.loading
                              ? CircularProgressIndicator()
                              : Text(
                                  signInButtonStr,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              indent: 15,
                              endIndent: 5,
                            )),
                            Text(dividerOrStr),
                            Expanded(
                                child: Divider(
                              indent: 5,
                              endIndent: 15,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   height: 70,
                            //   width: 100,
                            //   child: ElevatedButton(
                            //       style: ElevatedButton.styleFrom(
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(10))),
                            //       onPressed: () {},
                            //       child: Icon(
                            //         Icons.facebook,
                            //         size: 45,
                            //         color: Colors.blue,
                            //       )),
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    googleLogin();
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/google.png"),
                                      Text("Signin with Google"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              dontHaveAccountStr,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 45,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupPage(),
                                      ),
                                      (route) => false);
                                },
                                child: Text(
                                  signUpButtonStr,
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff1161FC)),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  googleLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    print(user);
    String? token = await user?.getIdToken();
    if (token!.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogin", true);
      prefs.setString("userId", user!.uid);
      prefs.setString("authenticationType", "google");
      prefs.setString("userName", user.displayName!);
      prefs.setString("userEmail", user.email!);
      prefs.setString("userRole", "user");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(),
          ),
          (route) => false);
    }
  }
}
