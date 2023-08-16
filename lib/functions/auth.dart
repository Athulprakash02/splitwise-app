import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

final _auth = FirebaseAuth.instance;
String verifyId = '';
String countryCode = '+91';
Future<void> phoneAuthentication(
    String number, BuildContext context) async {
 try {
    await _auth.verifyPhoneNumber(
    phoneNumber: countryCode+number,
    
    verificationCompleted: (PhoneAuthCredential credential) async {
      
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (error) {
      showSnackBar(context, Colors.red, error.message.toString());
    },
    codeSent: (verificationId, forceResendingToken) {
      verifyId = verificationId;
    },
    codeAutoRetrievalTimeout: (verificationId) {
      
    },
  );
 }on FirebaseAuthException catch (e) {
  print(e.message);
   
 }
}

Future<bool> verifyOTP(String otp) async {
  var credentials = await _auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp));

      return credentials.user != null ? true : false;
}
