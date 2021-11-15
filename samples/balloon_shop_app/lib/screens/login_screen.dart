import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/components/rounded_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const route = "/";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? userEmail;
  String? userPassword;

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                          child: Text(
                        "BALLOON SHOP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 28.0,
                            fontFamily: 'Sen',
                            letterSpacing: 6.0),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 1,
                      width: 150,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    SizedBox(height: 20.0),
                    RoundedTextField(
                      prefixIcon: Icons.person,
                      hintText: "Enter your email",
                      onChanged: (value) => {userEmail = value},
                    ),
                    RoundedTextField(
                      prefixIcon: Icons.lock,
                      hintText: "Enter your password",
                      obscureText: true,
                      onChanged: (value) => {userPassword = value},
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
                onPressed: () => {
                  print("login pressed: $userEmail, $userPassword"),
                },
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10.0),
                  height: 60.0,
                  child: Center(
                      child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: 'Sen',
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                        color: Color.fromARGB(0xFF, 0x47, 0x16, 0x9F)),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
