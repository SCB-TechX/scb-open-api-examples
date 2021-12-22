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
