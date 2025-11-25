import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    authProvider.emailTextField.clear();
    authProvider.passwordTextField.clear();
  }

  RegExp regExp = RegExp(emailPattern);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) => Consumer<IconsProvider>(
        builder: (context, iconsProvider, child) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Delete Your Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your registered email address and password to delete your account.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Email Input Field
                  CustomTextFormField(
                    controller: authProvider.emailTextField,
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
                  const SizedBox(height: 30),
                  CustomTextFormField(
                      obscureText: iconsProvider.showPassword ? false : true,
                      controller: authProvider.passwordTextField,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return passwordValidationStr;
                        } else if (value.length < 8) {
                          return passwordLengthValidationStr;
                        }
                        return null;
                      },
                      labelText: currentPasswordStr,
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

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await deleteShowDialog(context, authProvider);
                        // if (authProvider
                        //         .getResetUserPasswordFromCurrentPasswordStatus ==
                        //     StatusUtil.success) {
                        //   Helper.displaySnackbar(context, "Password Updated.");
                        //   Navigator.pop(context);
                        // } else if (authProvider
                        //         .getResetUserPasswordFromCurrentPasswordStatus ==
                        //     StatusUtil.error) {
                        //   Helper.displaySnackbar(context, "Operation Failed.");
                        // }
                      },
                      child: authProvider.getResetUserPasswordStatus ==
                              StatusUtil.loading
                          ? CircularProgressIndicator()
                          : const Text(
                              "Delete Account",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Back to login link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            color: buttonBackgroundColor, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteShowDialog(BuildContext context, AuthenticationProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
              onPressed: () async {
                await authProvider.deleteAccount();
                if (authProvider.getdeleteAccountstatus == StatusUtil.success) {
                  Helper.displaySnackbar(context, "Data Successfully deleted");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomBottomNavigationBar(
                          initialIndex: 3,
                        ),
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
}
