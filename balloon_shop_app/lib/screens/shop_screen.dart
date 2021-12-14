import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);
  static const route = "/shop";

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  void _onCheckoutClick() async {
    http.Response response = await http.post(
        Uri.https('balloon-shop-backend.herokuapp.com', '/payment/deeplink'),
        headers: {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMUBzYW1wbGUuY29tIiwiaWF0IjoxNjM3NzI1Mzk0OTkxfQ.5Fmw4RxXlTk0GdYCECGnldUMVPQdZmaJ7HcCfOmEFk4'
        });
    var checkoutDeeplink = jsonDecode(response.body)['deeplinkUrl'];
    print(checkoutDeeplink);
    if (await canLaunch(checkoutDeeplink)) {
      var launchResult = await launch(checkoutDeeplink);
    } else {
      print('cannot launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(),
                  ),
                  Container(
                    height: 150,
                    color: Colors.teal,
                  ),
                  Container(
                    height: 120,
                    color: Colors.indigo,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
                      onPressed: _onCheckoutClick,
                      child: Container(
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
                      ))
                ],
              ),
            )));
  }
}
