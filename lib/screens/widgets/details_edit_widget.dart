
import 'package:flutter/material.dart';

class DetailsFeild extends StatelessWidget {
  const DetailsFeild({
    super.key,
    required TextEditingController amountController, required this.text, required this.hintText,
  }) : _amountController = amountController;

  final TextEditingController _amountController;
  final String text;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ],
      ),
    );
  }

 
}