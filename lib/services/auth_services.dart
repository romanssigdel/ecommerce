import 'package:ecommerce/core/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServices {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<ApiResponse> signIn({required String email, required String password});
  Future<ApiResponse> createAccount(
      {required String email, required String password,required String role});
  Future<ApiResponse> signOut();
  Future<ApiResponse> resetPassword({required String email});
  Future<ApiResponse> updateUsername({required String username});
  Future<ApiResponse> deleteAccount({required String email, required String password});
  Future<ApiResponse> resetPasswordFromCurrentPassword(
      {required String email,
      required String currentPassword,
      required String newPassword});
}
