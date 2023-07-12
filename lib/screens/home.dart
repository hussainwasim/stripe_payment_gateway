import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntent;
  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // applePay:
          //     const PaymentSheetApplePay(merchantCountryCode: '+92'),
          // googlePay:
          //     const PaymentSheetGooglePay(merchantCountryCode: '+91'),
          merchantDisplayName: 'Wasim',
          style: ThemeMode.light,
          googlePay: gpay,
        ),
      );
      displayPaymentSheet();
      // print('done');
    } catch (e) {
      print('failed');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('done');
    } catch (e) {
      print('failed');
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "100",
        "country": "USD",
      };
      http.Response response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorazation": " Bearer sk_test_tR3PYbcVNZZ796tH88S4VQ2u",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STRIPE PAYMENT"),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            makePayment();
          },
          child: Text("Click here"),
        ),
      ),
    );
  }
}
