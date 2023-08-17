import 'package:flutter/material.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/otp_screen.dart';

import 'widgets/login_textfeild.dart';

class LoginWithOtpScreen extends StatelessWidget {
  LoginWithOtpScreen({super.key});
  final TextEditingController _phoneNumberController = TextEditingController();

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
            loginTextFeild(_phoneNumberController, 'Phone number',
                TextInputType.phone, ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  await phoneAuthentication(
                      _phoneNumberController.text, context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen(),
                  ));
                },
                child: const Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 16),
                ))
          ],
        ),
      )),
    );
  }
}
