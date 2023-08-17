import 'package:flutter/widgets.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';
import 'package:splitwise_app/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // final firebaseUser = context.watch<User?>();
    if (currentUser != null) {
      return const HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
