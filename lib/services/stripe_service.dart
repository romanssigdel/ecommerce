import 'package:dio/dio.dart';
import 'package:ecommerce/utils/api_const.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeService {
  String? userEmail;
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(int amount) async {
    try {
      // Retrieve user email from SharedPreferences
      await getValueOfUserFromSharedPreference();

      // Create a customer first
      String? customerId = await _createCustomer(userEmail!);
      if (customerId == null) return false;

      // Create the payment intent for the customer
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, "npr", customerId);
      if (paymentIntentClientSecret == null) return false;

      // Initialize Stripe Payment Sheet with email and customer ID
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "epasal",
          billingDetails: BillingDetails(
            email: userEmail, // The email will be used here for the payment
            address: Address(
              city: "Kathmandu",
              country: "NP",
              line1: "",
              line2: "",
              postalCode: "",
              state: "",
            ),
          ),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      // await Stripe.instance.confirmPaymentSheetPayment();
      return true;
    } catch (e) {
      print("Error in makePayment: $e");
      return false;
    }
  }

  Future<String?> _createPaymentIntent(
      int amount, String currency, String customerId) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
        "customer": customerId, // Attach the created customer ID here
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"]; // Return the client secret
      }
      return null;
    } catch (e) {
      print("Error in _createPaymentIntent: $e");
    }
    return null;
  }

  Future<String?> _createCustomer(String email) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "email": email, // Pass the user's email here
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/customers",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.data != null) {
        return response.data["id"]; // Return the customer ID
      }
      return null;
    } catch (e) {
      print("Error in _createCustomer: $e");
    }
    return null;
  }

  // Future<void> _processPayment() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     await Stripe.instance.confirmPaymentSheetPayment();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }

  getValueOfUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString("userEmail");
  }
}
