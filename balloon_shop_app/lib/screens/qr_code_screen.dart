import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key, this.qrImage}) : super(key: key);
  static const route = "/qr";
  final String? qrImage;

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  bool showLoadingSpinner = false;

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
      child: ModalProgressHUD(
        inAsyncCall: showLoadingSpinner,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("QR CODE",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    fontFamily: 'Sen',
                    letterSpacing: 2.0)),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(base64Decode(widget.qrImage!)),
                          fit: BoxFit.fitWidth))),
            ),
          ),
        ),
      ),
    );
    // image:
  }
}
