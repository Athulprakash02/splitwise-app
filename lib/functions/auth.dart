import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/core/constants.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';
import 'package:splitwise_app/screens/login_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

final _auth = FirebaseAuth.instance;
String verifyId = '';
String countryCode = '+91';

User? get currentUser => _auth.currentUser;
Stream<User?> get authState => _auth.authStateChanges();

Future<void> phoneAuthentication(String number, BuildContext context) async {
  try {
    await _auth.verifyPhoneNumber(
      phoneNumber: countryCode + number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (error) {
        showSnackBar(context, Colors.red, error.message.toString());
      },
      codeSent: (verificationId, forceResendingToken) {
        verifyId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, themeColor, e.message.toString());
  }
}

Future<bool> verifyOTP(String otp) async {
  var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp));

  return credentials.user != null ? true : false;
}

Future<void> signUpWithEmail(
    {required String email,
    required String password,
    required BuildContext context}) async {
  try {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
           showSnackBar(
                            context, Colors.green, 'Registered Succesfully!!');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    });
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, themeColor, e.message.toString());
  }
}

Future<void> loginWithEmailAndPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  try {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, themeColor, e.message.toString());
  }
}

validCheck(String email, String password, BuildContext ctx) {
  if (email == '' || password == "") {
    showSnackBar(ctx, themeColor, 'Please fill all the feilds');
  } else if (password.length < 6) {
    showSnackBar(ctx, themeColor, 'Minimum 6 characters required for password');
  }
}
