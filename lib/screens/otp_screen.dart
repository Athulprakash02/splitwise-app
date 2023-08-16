import 'package:flutter/material.dart';

import 'widgets/login_textfeild.dart';

class OTPScreen extends StatelessWidget {
   OTPScreen({super.key});
final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(child: Padding(
        padding:  EdgeInsets.all(size.width/16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextFeild(_otpController, 'Otp', TextInputType.phone,6),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: () {
              
            }, child: Text('Login',style: TextStyle(fontSize: 16),))
           
          ],
        ),
      )),
    );
  }
}