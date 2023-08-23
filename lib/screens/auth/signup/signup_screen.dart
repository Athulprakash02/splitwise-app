import 'package:flutter/material.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/auth/login/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/textfeilds_email_login.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
                //  Text('Sign up',style: TextStyle(fontSize: size.width/10,fontWeight: FontWeight.bold),),
                // SizedBox(height: size.width/18,),
                Image.asset(
                  'assets/images/signup.png',
                  width: size.width * .5,
                ),
                TextFieldsEmailLogin(
                    label: 'Full name',
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    obsureText: false),
                SizedBox(
                  height: size.width / 20,
                ),

                TextFieldsEmailLogin(
                    label: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obsureText: false),
                SizedBox(
                  height: size.width / 20,
                ),
                TextFieldsEmailLogin(
                    label: 'Phone number',
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    obsureText: false),
                SizedBox(
                  height: size.width / 20,
                ),
                TextFieldsEmailLogin(
                    label: AppLocalizations.of(context)!.password,
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obsureText: true),
                SizedBox(
                  height: size.width / 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.trim().isNotEmpty &&
                          _passwordController.text.trim().length >= 6) {
                        signUpWithEmail(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            context: context);
                      } else {
                        validCheck(_emailController.text.trim(),
                            _passwordController.text.trim(), context);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.singup,
                      style: const TextStyle(fontSize: 16),
                    )),
                // SizedBox(height: size.width/18,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.alreadyHaveAnAcc,
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(fontSize: 18),
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
