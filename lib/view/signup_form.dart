import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  RegExp regExp = RegExp(emailPattern);
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
                            createAccountStr,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          onChanged: (value) {
                            userProvider.setName(value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return nameValidationStr;
                            }
                            return null;
                          },
                          labelText: nameStr,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          onChanged: (value) {
                            userProvider.setEmail(value);
                          },
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
                        Visibility(
                          visible: false,
                          child: TextFormField(
                            controller: userProvider.setRole("user"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                            obscureText:
                                iconsProvider.showPassword ? false : true,
                            onChanged: (value) {
                              userProvider.setPassword(value);
                            },
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
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                            obscureText: iconsProvider.showConfirmPassword
                                ? false
                                : true,
                            onChanged: (value) {
                              userProvider.setConfirmPassword(value);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return confirmPasswordValidationStr;
                              } else if (value.length < 8) {
                                return passwordLengthValidationStr;
                              } else if (value != userProvider.password) {
                                return passwordMatchValidationStr;
                              }
                              return null;
                            },
                            labelText: confirmPasswordStr,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 30,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                iconsProvider.setShowConfirmPassword();
                              },
                              icon: iconsProvider.showConfirmPassword
                                  ? Icon(
                                      Icons.visibility,
                                      size: 30,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          backgroundColor: buttonBackgroundColor,
                          foregroundColor: buttonForegroundColor,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await userProvider.saveStudentData();
                              if (userProvider.saveUserStatus ==
                                  StatusUtil.success) {
                                if (userProvider.isSuccess) {
                                  Helper.displaySnackbar(
                                      context, dataSuccessfullySavedStr);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomBottomNavigationBar(
                                          initialIndex: 3,
                                        ),
                                      ),
                                      (route) => false);
                                }
                              } else if (userProvider.saveUserStatus ==
                                  StatusUtil.error) {
                                Helper.displaySnackbar(
                                    context, userProvider.errorMessage);
                              }
                            }
                          },
                          child:
                              userProvider.saveUserStatus == StatusUtil.loading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      signUpButtonStr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                        ),
                        SizedBox(
                          height: 10,
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     SizedBox(
                        //       height: 70,
                        //       width: 100,
                        //       child: ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10))),
                        //           onPressed: () {},
                        //           child: Icon(
                        //             Icons.facebook,
                        //             size: 45,
                        //             color: Colors.blue,
                        //           )),
                        //     ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     SizedBox(
                        //       height: 70,
                        //       width: 100,
                        //       child: ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10))),
                        //           onPressed: () {},
                        //           child:
                        //               Image.asset("assets/images/google.png")),
                        //     ),
                        //   ],
                        // ),
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
                              alreadyHaveAccountStr,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomBottomNavigationBar(
                                        initialIndex: 3,
                                      ),
                                    ),
                                    (route) => false);
                              },
                              child: Text(signInButtonStr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: buttonBackgroundColor)),
                            ),
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
}
