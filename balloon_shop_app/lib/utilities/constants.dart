import 'package:flutter/material.dart';

const kBalloonShopBackendEndpoint =
    String.fromEnvironment('BALLOON_SHOP_BACKEND_ENDPOINT',
        // defaultValue: 'balloon-shop-backend.herokuapp.com');
        defaultValue: '8558-2405-9800-b820-696-e8ae-cbc1-dd03-d29d.ngrok.io');

const kUriLogin = '/token';
const kUriGetProducts = '/products';
const kUriCreatePaymentDeeplink = '/payment/deeplink';
const kUriCreatePaymentQr = '/payment/qr';
const kUriGetPaymentQrResult = '/payment/qr/result';

const kAccessTokenKey = 'accessToken';

const kHeaderAuthorization = 'Authorization';

const kAppBackgroundColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(0xFF, 0x47, 0x16, 0x9F),
      Color.fromARGB(0xFF, 0x9F, 0x0D, 0xB7)
    ]);

const kAppBarTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    fontFamily: 'Sen',
    letterSpacing: 2.0);

const kProductTitleTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16.0,
);

const kProductPriceTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BebasNeue',
    letterSpacing: 2);

const kProductPriceUnitTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BebasNeue',
    letterSpacing: 2);

const kProductAmountTextStyle = TextStyle(
    color: Colors.purple,
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'BebasNeue',
    letterSpacing: 2);

const kBoxLabelTextStyle = TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black54);

const kTotalPriceTextStyle = TextStyle(
    color: Colors.purple,
    fontSize: 60.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'BebasNeue',
    letterSpacing: 2);

const kTotalPriceUnitTextStyle = TextStyle(
    color: Colors.purple,
    fontSize: 30.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'BebasNeue',
    letterSpacing: 2);

const kPaymentMethodTitleTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const kPaymentMethodDescriptionTextStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

const kBottomButtonTextStyle = TextStyle(
    fontFamily: 'Sen',
    fontSize: 20.0,
    letterSpacing: 2.0,
    color: Color.fromARGB(0xFF, 0x47, 0x16, 0x9F));

const kBorderRadiusCommon = Radius.circular(16.0);
const kShopBoxDecoration = BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.all(kBorderRadiusCommon));
