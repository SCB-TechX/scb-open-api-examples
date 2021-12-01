import 'package:flutter/material.dart';

const kContentColor = Color.fromARGB(0xFF, 0xA1, 0xA1, 0xA1);

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key? key,
    required this.prefixIcon,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);
  final IconData prefixIcon;
  final String hintText;
  final bool obscureText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5.0),
        child: TextField(
          onChanged: onChanged,
          textAlign: TextAlign.center,
          obscureText: obscureText,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                prefixIcon,
                color: kContentColor,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: kContentColor,
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        ));
  }
}
