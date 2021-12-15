import 'dart:async';

import 'package:balloon_shop_app/screens/login_screen.dart';
import 'package:balloon_shop_app/screens/qr_code_screen.dart';
import 'package:balloon_shop_app/screens/result_screen.dart';
import 'package:balloon_shop_app/screens/shop_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() => {runApp(const BalloonShopApp())};

class BalloonShopApp extends StatefulWidget {
  const BalloonShopApp({Key? key}) : super(key: key);

  @override
  _BalloonShopAppState createState() => _BalloonShopAppState();
}

class _BalloonShopAppState extends State<BalloonShopApp>
    with SingleTickerProviderStateMixin {
  StreamSubscription? _sub;

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          Navigator.pushNamed(context, ResultScreen.route);
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Shop',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
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
