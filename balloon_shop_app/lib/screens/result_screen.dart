import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const route = "/result";

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'SUCCESS',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 28.0,
                            fontFamily: 'Sen',
                            letterSpacing: 6.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
                    onPressed: () => {Navigator.pop(context)},
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10.0),
                      height: 60.0,
                      child: Center(
                          child: Text(
                        'BACK',
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
            )));
  }
}
