import 'package:flutter/material.dart';

class ButtonSelect extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonSelect({Key? key, required this.text, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEAECF0),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Color(0xFFDADADA)),
        ),
      ),
    );
  }
}
