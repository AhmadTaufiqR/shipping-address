import 'package:flutter/material.dart';

class CustomTextButton {
  static Widget normalCustomTextButton({
    void Function()? onTap,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
