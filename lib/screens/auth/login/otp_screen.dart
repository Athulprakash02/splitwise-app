import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

import '../../widgets/login_textfeild.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(size.width / 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextFeild(_otpController, 'Otp', TextInputType.phone, ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await verifyOTP(_otpController.text.trim()).then(
                        (value) => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false));
                  } on FirebaseAuthException catch (e) {
                    showSnackBar(context, Colors.red, e.message.toString());
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ))
          ],
        ),
      )),
    );
  }
}
