import 'dart:async';
import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/components/rounded_text_field.dart';
import 'package:balloon_shop_app/screens/result_screen.dart';
import 'package:balloon_shop_app/screens/shop_screen.dart';
import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const route = "/";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription? _sub;
  String? userEmail;
  String? userPassword;
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  bool showLoadingSpinner = false;

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

  void _onLoginClick() async {
    try {
      setState(() {
        showLoadingSpinner = true;
      });
      print("login pressed: $userEmail, $userPassword");
      http.Response response = await http.post(
          Uri.https(kBalloonShopBackendEndpoint, kUriLogin),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'email': userEmail, 'password': userPassword}));
      String accessToken = jsonDecode(response.body)['accessToken'];

      if (accessToken != null) {
        _saveAccessToken(accessToken);
        Navigator.pushNamed(context, ShopScreen.route);
      } else {
        _showLoginErrorDialog();
      }
      userEmail = "";
      userPassword = "";
      userEmailController.clear();
      userPasswordController.clear();
    } catch (e) {
      _showLoginErrorDialog();
    } finally {
      setState(() {
        showLoadingSpinner = false;
      });
    }
  }

  void _showLoginErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Login Failed'),
            content: new Text('Invalid email or password'),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('Try again'))
            ],
          );
        });
  }

  void _saveAccessToken(String accessToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('accessToken', accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showLoadingSpinner,
          child: SafeArea(
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
                        controller: userEmailController,
                        prefixIcon: Icons.person,
                        hintText: "Enter your email",
                        onChanged: (value) => {userEmail = value},
                      ),
                      RoundedTextField(
                        controller: userPasswordController,
                        prefixIcon: Icons.lock,
                        hintText: "And password",
                        obscureText: true,
                        onChanged: (value) => {userPassword = value},
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
                  onPressed: _onLoginClick,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10.0),
                    height: 60.0,
                    child: Center(
                        child: Text(
                      'LOGIN',
                      style: kBottomButtonTextStyle,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
