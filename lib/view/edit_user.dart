import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserData extends StatefulWidget {
  var id, name, email, password,role;
  EditUserData({super.key, this.id, this.name, this.email, this.password,this.role});

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  RegExp regExp = RegExp(emailPattern);
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController userPassword = TextEditingController(text: widget.password);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) => Form(
            key: _formKey,
            child: Consumer<IconsProvider>(
              builder: (context, iconsProvider, child) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Text(
                      createAccountStr,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    initialValue: widget.name,
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
                    initialValue: widget.email,
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
                    child: CustomTextFormField(
                      onChanged: userProvider.setId(widget.id),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: userProvider.setRole(widget.role),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                      initialValue: "${widget.password}",
                      obscureText: iconsProvider.showPassword ? false : true,
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
                      initialValue: "${widget.password}",
                      obscureText:
                          iconsProvider.showConfirmPassword ? false : true,
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
                        await userProvider.updateStudentData();
                        if (userProvider.updateUserStatus ==
                            StatusUtil.success) {
                          if (userProvider.isSuccess) {
                            Helper.displaySnackbar(
                                context, dataSuccessfullyUpdatedStr);
                            await logoutUserFromSharedPreference();
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
                    child: userProvider.saveUserStatus == StatusUtil.loading
                        ? CircularProgressIndicator()
                        : Text(
                            updateButtonStr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: Divider(
                  //       indent: 15,
                  //       endIndent: 5,
                  //     )),
                  //     Text(dividerOrStr),
                  //     Expanded(
                  //         child: Divider(
                  //       indent: 5,
                  //       endIndent: 15,
                  //     )),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      // Text(
                      //   alreadyHaveAccountStr,
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      // SizedBox(
                      //   width: 50,
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushAndRemoveUntil(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => CustomBottomNavigationBar(
                      //             initialIndex: 3,
                      //           ),
                      //         ),
                      //         (route) => false);
                      //   },
                      //   child: Text(signInButtonStr,
                      //       style: TextStyle(
                      //           fontSize: 16, color: buttonBackgroundColor)),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  logoutUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("");
    await prefs.remove("userId");
    await prefs.remove('isLogin');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    await prefs.remove('userPassword');
    // Helper.displaySnackbar(context, "Successfully Logged Out!");
  }
}
