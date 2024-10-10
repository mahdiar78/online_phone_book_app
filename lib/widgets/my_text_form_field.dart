import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.textType,
    required this.textController,
    required this.hintText,
    required this.errorText,
    required this.isEnabled,
  });

  final TextInputType textType;
  final TextEditingController textController;
  final String hintText;
  final String errorText;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorText;
          }
          return null;
        },
        controller: textController,
        enabled: isEnabled,
        textAlign: TextAlign.right,
        cursorColor: Colors.grey,
        keyboardType: textType,
        style: TextStyle(fontSize: 25),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 25, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          errorStyle: TextStyle(
            height: 1.5,
            color: Colors.red,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
