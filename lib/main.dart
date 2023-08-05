import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:splitwise_app/core/theme.dart';
import 'package:splitwise_app/model/participant_model.dart';
import 'package:splitwise_app/screens/expense_screen.dart';

Future<void> main(List<String> args) async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(ParticipantModelAdapter().typeId)) {
    Hive.registerAdapter(ParticipantModelAdapter());
  }

  await Hive.openBox<ParticipantModel>('participants');
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
      home: ExpenseScreen(),
    );
    
  }
}
