import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/api_response.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/services/auth_services.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_launcher_icons/constants.dart';

class AuthServicesImplementation implements AuthServices {
  bool isSucess = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  @override
  Future<ApiResponse> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.reload();
      User? updatedUser = firebaseAuth.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        // print(userCredential.user);
        return ApiResponse(
            statusUtil: StatusUtil.success,
            data: userCredential); // Allow login
      } else {
        // If not verified → sign out and throw error
        await firebaseAuth.signOut();
        return ApiResponse(
            statusUtil: StatusUtil.error,
            errorMessage: "SignIn error"); // Allow login
      }
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error,
          errorMessage: "SignIn error"); // Allow login
    }
  }

  @override
  Future<ApiResponse> createAccount(
      {required String email,
      required String password,
      required String role}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': role,
        'createdAt': Timestamp.now(),
      });
      if (userCredential.user != null) {
        isSucess = true;
        await userCredential.user!.sendEmailVerification();
        return ApiResponse(
          data: isSucess,
          statusUtil: StatusUtil.success,
        );
      } else {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: signupFailedStr);
      }
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> signOut() async {
    try {
      await firebaseAuth.signOut();
      isSucess = true;
      return ApiResponse(statusUtil: StatusUtil.success, data: isSucess);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      isSucess = true;
      return ApiResponse(statusUtil: StatusUtil.success, data: isSucess);
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> updateUsername({required String username}) async {
    try {
      if (currentUser != null && currentUser!.emailVerified) {
        await currentUser!.updateDisplayName(username);
        await currentUser!.reload();
        isSucess = true;
        return ApiResponse(statusUtil: StatusUtil.success, data: isSucess);
      } else {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: "Update error.");
      }
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }

  @override
  Future<ApiResponse> resetPasswordFromCurrentPassword(
      {required String email,
      required String currentPassword,
      required String newPassword}) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
      isSucess = true;
      return ApiResponse(statusUtil: StatusUtil.success, data: isSucess);
    } catch (e) {
      return ApiResponse(statusUtil: StatusUtil.error, data: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteAccount(
      {required String email, required String password}) async {
    try {
      if (currentUser != null && currentUser!.emailVerified) {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await currentUser!.reauthenticateWithCredential(credential);
        await currentUser!.delete();
        await firebaseAuth.signOut();
        isSucess = true;
        return ApiResponse(statusUtil: StatusUtil.success, data: isSucess);
      } else {
        return ApiResponse(
            statusUtil: StatusUtil.error, errorMessage: "Deletion error.");
      }
    } catch (e) {
      return ApiResponse(
          statusUtil: StatusUtil.error, errorMessage: e.toString());
    }
  }
}
