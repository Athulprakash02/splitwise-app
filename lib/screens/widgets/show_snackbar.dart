 import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,Color color,String text) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        backgroundColor: color,
        content:  Center(
          child: Text(
            text,
            // style: const TextStyle(fontSize: 17),
          ),
        )));
  }