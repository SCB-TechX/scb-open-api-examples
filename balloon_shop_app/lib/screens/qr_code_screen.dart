import 'dart:async';
import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/screens/result_screen.dart';
import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key, this.qrImage, this.qrId}) : super(key: key);
  static const route = "/qr";
  final String? qrImage;
  final String? qrId;

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? accessToken;
  bool showLoadingSpinner = false;

  void _loadingScreenData() async {
    try {
      setState(() {
        showLoadingSpinner = true;
      });
      await _getAccessToken();
      _getTransactionResultByQrCode();
    } finally {
      setState(() {
        showLoadingSpinner = false;
      });
    }
  }

  Future<void> _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.get(kAccessTokenKey).toString();
  }

  Future<void> _getTransactionResultByQrCode() async {
    try {
      print("qrId ${widget.qrId}");
      final response = await http.get(
          Uri.https(kBalloonShopBackendEndpoint, kUriGetPaymentQrResult,
              {'qrId': widget.qrId}),
          headers: {
            kHeaderAuthorization: "Bearer $accessToken"
          }).timeout(const Duration(hours: 1));
      if ((response.statusCode ~/ 100) == 2) {
        Navigator.pushReplacementNamed(context, ResultScreen.route);
      }
    } on TimeoutException catch (e) {
      print("TimeoutException");
      _getTransactionResultByQrCode();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingScreenData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
      child: ModalProgressHUD(
        inAsyncCall: showLoadingSpinner,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("QR CODE"),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 380,
                    margin:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(kCommonRadius),
                        image: DecorationImage(
                            image: MemoryImage(base64Decode(widget.qrImage!)),
                            fit: BoxFit.fitWidth))),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  padding: EdgeInsets.all(6),
                  width: double.infinity,
                  decoration: kCommonBoxDecoration,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: kDescriptionBoxDecoration,
                    child: Text(
                      'Scan this QR code with\nSCB EASY Simulator App',
                      textAlign: TextAlign.center,
                      style: kQrCodeDescriptionTextStyle,
                    ),
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
