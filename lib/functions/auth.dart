import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splitwise_app/core/constants.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/model/user%20model/user_model.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';
import 'package:splitwise_app/screens/auth/login/login_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

final _auth = FirebaseAuth.instance;
String verifyId = '';
String countryCode = '+91';
String userType = '';

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
    required BuildContext context,
    required UserModel user}) async {
  try {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      cerateUser(user);
      showSnackBar(context, Colors.green, 'Registered Succesfully!!');
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
      //  await fetchCurrentUser();
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

Future<void> cerateUser(UserModel user) async {
  await firestore.collection('Users').add(user.toJson());
}

// Future<void> fetchCurrentUser() async {
//   print('ivde ethiyee');
//   print(currentUser!.email);
//   final userColection = FirebaseFirestore.instance.collection('Users');
//   final querySnapShot = await userColection
//       .where('email', isEqualTo: currentUser!.email)
//       .limit(1)
//       .get();
//   final userDocument = querySnapShot.docs.first;
//   print(userDocument.id);
//   var type = userDocument['User type'];
//   userType = type;
//   print(userType);
// }
Future<DocumentSnapshot<Map<String, dynamic>>?> getUserTypeByEmail(
    String email) async {
  final userColection = FirebaseFirestore.instance.collection('Users');
  final querySnapShot =
      await userColection.where('email', isEqualTo: email).limit(1).get();
  if (querySnapShot.docs.isNotEmpty) {
    return querySnapShot.docs.first;
  } else {
    return null;
  }
}

final googleSignIn = GoogleSignIn();

GoogleSignInAccount? _user;
GoogleSignInAccount get user => _user!;

Future googleLogin(BuildContext context) async {
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return;
  }
  _user = googleUser;

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  try {
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
    // ignore: empty_catches
  } catch (e) {}
}
