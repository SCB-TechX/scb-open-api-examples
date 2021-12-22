import 'package:balloon_shop_app/screens/login_screen.dart';
import 'package:balloon_shop_app/screens/qr_code_screen.dart';
import 'package:balloon_shop_app/screens/result_screen.dart';
import 'package:balloon_shop_app/screens/shop_screen.dart';
import 'package:flutter/material.dart';

void main() => {runApp(const BalloonShopApp())};

class BalloonShopApp extends StatefulWidget {
  const BalloonShopApp({Key? key}) : super(key: key);

  @override
  _BalloonShopAppState createState() => _BalloonShopAppState();
}

class _BalloonShopAppState extends State<BalloonShopApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Shop',
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          appBarTheme: const AppBarTheme(color: Colors.deepPurple),
          fontFamily: 'Roboto'),
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (context) => LoginScreen(),
        ShopScreen.route: (context) => ShopScreen(),
        ResultScreen.route: (context) => ResultScreen(),
        QrCodeScreen.route: (context) => QrCodeScreen(),
      },
    );
  }
}
