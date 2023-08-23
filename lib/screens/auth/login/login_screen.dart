import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitwise_app/controllers/locale_provider.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/auth/login/login_with_otp.dart';
import 'package:splitwise_app/screens/auth/signup/signup_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/textfeilds_email_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(size.width / 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login.png',
                  width: size.width * .4,
                ),
                SizedBox(
                  height: size.width / 20,
                ),
                TextFieldsEmailLogin(
                    label: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obsureText: false),
                SizedBox(
                  height: size.width / 16,
                ),
                TextFieldsEmailLogin(
                    label: AppLocalizations.of(context)!.password,
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
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(fontSize: 16),
                    )),
                // SizedBox(height: size.width/18,),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginWithOtpScreen(),
                      ));
                    },
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.loginWithOtp,
                      style: const TextStyle(fontSize: 18),
                      maxLines: 1,
                    )),

                // SizedBox(height: size.width/20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dontHaveAnAcc,
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.singup,
                          style: const TextStyle(fontSize: 16),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          provider.setLocale(const Locale('en'));
                        },
                        child: const Text('English')),
                    TextButton(
                        onPressed: () {
                          provider.setLocale(const Locale('ml'));
                        },
                        child: const Text('Malayalam')),
                    TextButton(
                        onPressed: () {
                          provider.setLocale(const Locale('hi'));
                        },
                        child: const Text('Hindi'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
