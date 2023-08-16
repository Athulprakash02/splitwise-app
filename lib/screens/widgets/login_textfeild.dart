 import 'package:flutter/material.dart';

TextFormField loginTextFeild(TextEditingController controller,String label,TextInputType keyboardType ){
    return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          // maxLength: length,
          decoration: InputDecoration(
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            label: Text(label),
            
            
          ),
        );
  }