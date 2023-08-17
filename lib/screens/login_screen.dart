import 'package:flutter/material.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/login_with_otp.dart';
import 'package:splitwise_app/screens/signup_screen.dart';

import 'widgets/textfeilds_email_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(size.width / 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.png',width: size.width*.4,),
                SizedBox(height: size.width/20,),
                TextFieldsEmailLogin(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obsureText: false),
                SizedBox(
                  height: size.width / 16,
                ),
                TextFieldsEmailLogin(
                    label: 'Password',
                    controller: _paswordController,
                    keyboardType: TextInputType.text,
                    obsureText: true),
                SizedBox(
                  height: size.width / 16,
                ),
                ElevatedButton(
                    onPressed: () {
                       if (_emailController.text.trim().isNotEmpty &&
                          _paswordController.text.trim().length >= 6) {
                        loginWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _paswordController.text.trim(),
                            context: context);
                      } else {
                        validCheck(_emailController.text.trim(),
                            _paswordController.text.trim(), context);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    )),
                // SizedBox(height: size.width/18,),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginWithOtpScreen(),
                      ));
                    },
                    child: const Text(
                      'Login with otp',
                      style: TextStyle(fontSize: 17),
                    )),
          
                // SizedBox(height: size.width/20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
