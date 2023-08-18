import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splitwise_app/core/theme.dart';
import 'package:splitwise_app/screens/auth_wrapper.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'high importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBakgroundHAndler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('bg message : ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessagingBakgroundHAndler(message));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
      home: const AuthWrapper(),
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
