import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/core/theme.dart';
import 'package:splitwise_app/screens/login_screen.dart';
import 'package:splitwise_app/screens/login_with_otp.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Splitwise',
          theme: theme,
          home:  LoginScreen(),
        );
    // return MultiProvider(providers: [
    //   ChangeNotifierProvider(
    //     create: (context) => GroupProvider(),
    //     child: MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Splitwise',
    //       theme: theme,
    //       home: HomeScreen(),
    //     ),
    //   )
    // ]);
  }
}
