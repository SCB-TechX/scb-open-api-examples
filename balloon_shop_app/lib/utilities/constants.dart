import 'package:flutter/material.dart';

const kBalloonShopBackendEndpoint = String.fromEnvironment(
    'BALLOON_SHOP_BACKEND_ENDPOINT',
    defaultValue: 'balloon-shop-backend.herokuapp.com');

const kUriLogin = '/token';
const kUriGetProducts = '/products';
const kUriCreatePaymentDeeplink = '/payment/deeplink';
const kUriCreatePaymentQr = '/payment/qr';

const kAccessTokenKey = 'accessToken';

const kHeaderAuthorization = 'Authorization';

const kAppBackgroundColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(0xFF, 0x47, 0x16, 0x9F),
      Color.fromARGB(0xFF, 0x9F, 0x0D, 0xB7)
    ]);
