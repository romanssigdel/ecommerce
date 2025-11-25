import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/provider/icons_providers.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUsername extends StatefulWidget {
  const UpdateUsername({super.key});

  @override
  State<UpdateUsername> createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    authProvider.emailTextField.clear();
    authProvider.passwordTextField.clear();
    authProvider.confirmPasswordTextField.clear();
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
                    "Update Your Username",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your new username.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),

                  // Email Input Field
                  CustomTextFormField(
                    controller: authProvider.newUsernameTextField,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return nameValidationStr;
                      } else if (value.length < 5) {
                        return userNamelengthValidationStr;
                      }
                      return null;
                    },
                    labelText: newUserNameStr,
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
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
                        await authProvider.updateUsername();
                        if (authProvider.getUpdateUsernametatus ==
                            StatusUtil.success) {
                          Helper.displaySnackbar(context, "Username Updated.");
                          Navigator.pop(context);
                        } else if (authProvider.getUpdateUsernametatus ==
                            StatusUtil.error) {
                          Helper.displaySnackbar(context, "Operation Failed.");
                        }
                      },
                      child: authProvider.getUpdateUsernametatus ==
                              StatusUtil.loading
                          ? CircularProgressIndicator()
                          : const Text(
                              "Update Username",
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
}
