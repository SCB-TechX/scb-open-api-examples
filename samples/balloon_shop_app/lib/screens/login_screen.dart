import 'package:balloon_shop_app/components/rounded_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const route = "/";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(0xFF, 0x47, 0x16, 0x9F),
            Color.fromARGB(0xFF, 0x9F, 0x0D, 0xB7)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5.0),
                child: RoundedTextField(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5.0),
                child: RoundedTextField(),
              ),
              Container(
                  child: ElevatedButton(
                child: Text('Sign In'),
                onPressed: () => {},
              )),
            ],
          ),
        ),
      ),
    );
  }
}
