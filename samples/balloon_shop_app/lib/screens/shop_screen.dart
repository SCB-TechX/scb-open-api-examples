import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);
  static const route = "/shop";

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.brown,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.pink,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.teal,
                  )),
                  Expanded(
                      child: Container(
                    color: Colors.indigo,
                  )),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.0),
                    height: 60.0,
                    child: Center(
                        child: Text(
                      'CHECKOUT',
                      style: TextStyle(
                          fontFamily: 'Sen',
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                          color: Color.fromARGB(0xFF, 0x47, 0x16, 0x9F)),
                    )),
                  )
                ],
              ),
            )));
  }
}
