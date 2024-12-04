import 'package:flutter/material.dart';

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final int length;
  final Color borderColor;
  final double borderRadius;
  final double boxSpacing;
  final double fontSize;

  const OTPInputField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.length = 4,
    this.borderColor = Colors.black,
    this.borderRadius = 12.0,
    this.boxSpacing = 10.0,
    this.fontSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 4, // Limit to 4 digits
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 40, // Adjust to control spacing
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          counterText: '', // Hides the counter
          hintText: 'Enter OTP',
          hintStyle: const TextStyle(
            letterSpacing: 0, // No extra spacing for hint
            color: Colors.grey,
          ),
        ),
        onChanged: (value) {
          if (value.length == 4) {
            FocusScope.of(context)
                .unfocus(); // Dismiss keyboard when input is complete
          }
        },
      ),
    );
  }
}
