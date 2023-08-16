import 'package:flutter/material.dart';
import 'package:splitwise_app/screens/otp_screen.dart';

import 'widgets/login_textfeild.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  final TextEditingController _phoneNumberController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(child: Padding(
        padding:  EdgeInsets.all(size.width/16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextFeild(_phoneNumberController, 'Phone number', TextInputType.phone,10),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTPScreen(),));
            }, child: Text('Send OTP',style: TextStyle(fontSize: 16),))
           
          ],
        ),
      )),
    );
  }

 
}