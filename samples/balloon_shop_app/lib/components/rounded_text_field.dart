import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => {},
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            Icons.person,
            color: Color.fromARGB(0xFF, 0xA1, 0xA1, 0xA1),
          ),
          hintText: "Enter your email",
          hintStyle: TextStyle(
            color: Color.fromARGB(0xFF, 0xA1, 0xA1, 0xA1),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
    );
  }
}
