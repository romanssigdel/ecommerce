import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  RegExp regExp = RegExp(emailPattern);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your registered email address below to receive a password reset link.",
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
                      await authProvider.resetUserPassword();
                      if (authProvider.getResetUserPasswordStatus ==
                          StatusUtil.success) {
                        Helper.displaySnackbar(context,
                            "Password Reset link sent to your Email Address.");
                        Navigator.pop(context);
                      } else if (authProvider.getResetUserPasswordStatus ==
                          StatusUtil.error) {
                        Helper.displaySnackbar(context, "Operation Failed.");
                      }
                    },
                    child: authProvider.getResetUserPasswordStatus ==
                            StatusUtil.loading
                        ? CircularProgressIndicator()
                        : const Text(
                            "Send Reset Link",
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
                      "Back to Login",
                      style:
                          TextStyle(color: buttonBackgroundColor, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
