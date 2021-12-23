import 'dart:convert';
import 'dart:io';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/components/product_card.dart';
import 'package:balloon_shop_app/screens/login_screen.dart';
import 'package:balloon_shop_app/screens/qr_code_screen.dart';
import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum PaymentMethod { qr, easy }

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);
  static const route = "/shop";

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool showLoadingSpinner = true;
  String? accessToken;
  List<Object>? products;
  Map<String, int> productOrders = {};
  double totalPrice = 0;
  PaymentMethod selectedPaymentMethod = PaymentMethod.qr;

  @override
  void initState() {
    super.initState();
    _loadingScreenData();
  }

  String _createRequestBody() {
    List<dynamic> orders = [];
    productOrders.forEach((key, value) {
      orders.add({'_id': key, 'amount': value});
    });
    return jsonEncode({'orderedProducts': orders});
  }

  void _onCheckoutClick() async {
    setState(() {
      showLoadingSpinner = true;
    });
    try {
      if (selectedPaymentMethod == PaymentMethod.easy) {
        http.Response response = await http.post(
            Uri.https(kBalloonShopBackendEndpoint, kUriCreatePaymentDeeplink),
            headers: {
              kHeaderAuthorization: "Bearer $accessToken",
              "Content-Type": "application/json"
            },
            body: _createRequestBody());
        var checkoutDeeplink = jsonDecode(response.body)['deeplinkUrl'];
        print(checkoutDeeplink);
        if (await canLaunch(checkoutDeeplink)) {
          var launchResult = await launch(checkoutDeeplink);
        } else {
          print('Cannot launch easy app');
        }
      } else {
        http.Response response = await http.post(
            Uri.https(kBalloonShopBackendEndpoint, kUriCreatePaymentQr),
            headers: {
              kHeaderAuthorization: "Bearer $accessToken",
              "Content-Type": "application/json"
            },
            body: _createRequestBody());
        if (response.statusCode == HttpStatus.ok) {
          var qrImage = jsonDecode(response.body)['qrImage'];
          var qrcodeId = jsonDecode(response.body)['qrcodeId'];

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QrCodeScreen(
                        qrImage: qrImage,
                        qrId: qrcodeId,
                      )));
        } else if (response.statusCode == HttpStatus.unauthorized) {
          _showSessionExpiredErrorDialog();
        }
      }
    } finally {
      setState(() {
        productOrders.clear();
        totalPrice = 0;
        showLoadingSpinner = false;
      });
    }
  }

  void _onAmountUpdated(String id, int amount) {
    productOrders[id] = amount;
    totalPrice = 0;
    for (var product in products!) {
      final data = product as Map;
      final id = data['_id'];
      final price = double.parse(data['price']);
      final amount = productOrders[id];
      if (amount != null) {
        totalPrice = totalPrice + (amount * price);
        print(totalPrice);
      }
    }
    setState(() {
      totalPrice = totalPrice;
    });
  }

  void _onSelectPaymentMethod(PaymentMethod type) {
    setState(() {
      selectedPaymentMethod = type;
    });
    print(selectedPaymentMethod);
  }

  void _loadingScreenData() async {
    try {
      setState(() {
        showLoadingSpinner = true;
      });
      await _getAccessToken();
      await _getProducts();
    } finally {
      setState(() {
        showLoadingSpinner = false;
      });
    }
  }

  Future<void> _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = await sharedPreferences.get(kAccessTokenKey).toString();
  }

  Future<void> _getProducts() async {
    try {
      setState(() {
        products = [];
        productOrders.clear();
        totalPrice = 0;
        showLoadingSpinner = true;
      });
      http.Response response = await http.get(
          Uri.https(kBalloonShopBackendEndpoint, kUriGetProducts),
          headers: {kHeaderAuthorization: "Bearer $accessToken"});
      setState(() {
        products = jsonDecode(response.body);
      });
    } finally {
      setState(() {
        showLoadingSpinner = false;
      });
    }
  }

  void _showSessionExpiredErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Session Expired'),
            content: new Text('You will be redirected to the login screen'),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName(LoginScreen.route));
                  },
                  child: new Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
        child: ModalProgressHUD(
      inAsyncCall: showLoadingSpinner,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("BALLOON SHOP"),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                  decoration: kCommonBoxDecoration,
                  height: 320,
                  child: Column(
                    children: [
                      BoxLabel(
                        value: 'CATALOG',
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _getProducts,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  products != null ? products!.length : 0,
                              itemBuilder: (context, index) {
                                final data = products![index] as Map;
                                return ProductCard(
                                  id: data['_id'],
                                  imageUrl: data['imageUrl'],
                                  price: data['price'],
                                  name: data['name'],
                                  onAmountUpdated: _onAmountUpdated,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    decoration: kCommonBoxDecoration,
                    height: 100,
                    width: double.infinity,
                    child: Center(
                        child: Column(
                      children: [
                        BoxLabel(value: 'TOTAL PRICE'),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  totalPrice.toStringAsFixed(2),
                                  style: kTotalPriceTextStyle,
                                ),
                                Text(
                                  '฿',
                                  style: kTotalPriceUnitTextStyle,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                  decoration: kCommonBoxDecoration,
                  height: 170,
                  width: double.infinity,
                  child: Column(
                    children: [
                      BoxLabel(
                        value: 'PAYMENT METHOD',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethodButton(
                            onPressed: _onSelectPaymentMethod,
                            paymentMethodValue: PaymentMethod.qr,
                            selectedPaymentMethod: selectedPaymentMethod,
                            imagePath: 'assets/api-icon-qr-code-circle.png',
                          ),
                          PaymentMethodButton(
                            onPressed: _onSelectPaymentMethod,
                            paymentMethodValue: PaymentMethod.easy,
                            selectedPaymentMethod: selectedPaymentMethod,
                            imagePath: 'assets/api-icon-payment-circle.png',
                          ),
                        ],
                      ),
                      Expanded(
                        child: PaymentMethodDescriptionBox(
                          selectedPaymentMethod: selectedPaymentMethod,
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
                    onPressed: _onCheckoutClick,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 4.0),
                      height: 60.0,
                      child: Center(
                          child: Text(
                        'CHECKOUT',
                        style: kBottomButtonTextStyle,
                      )),
                    ))
              ],
            ),
          )),
    ));
  }
}

class BoxLabel extends StatelessWidget {
  const BoxLabel({Key? key, required this.value}) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        value,
        style: kBoxLabelTextStyle,
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  const PaymentMethodButton(
      {Key? key,
      required this.onPressed,
      required this.selectedPaymentMethod,
      required this.imagePath,
      required this.paymentMethodValue})
      : super(key: key);
  final void Function(PaymentMethod) onPressed;
  final PaymentMethod selectedPaymentMethod;
  final PaymentMethod paymentMethodValue;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            color: selectedPaymentMethod == paymentMethodValue
                ? Colors.purple.shade400
                : Colors.grey.shade300,
            borderRadius: BorderRadius.all(kCommonRadius)),
        height: 60,
        width: 60,
        child: TextButton(
          child: Image.asset(
            imagePath,
            color: Colors.white,
            colorBlendMode: BlendMode.srcATop,
          ),
          onPressed: () => {onPressed(paymentMethodValue)},
        ));
  }
}

class PaymentMethodDescriptionBox extends StatelessWidget {
  const PaymentMethodDescriptionBox(
      {Key? key, required this.selectedPaymentMethod})
      : super(key: key);
  final PaymentMethod selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(6),
      decoration: kDescriptionBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedPaymentMethod == PaymentMethod.qr
                ? 'QR Code Payment'
                : 'SCB EASY App Payment',
            style: kPaymentMethodTitleTextStyle,
          ),
          Text(
              selectedPaymentMethod == PaymentMethod.qr
                  ? 'Generate QR code and enable customer to scan with their banking application.'
                  : 'Deep-linking to SCB EASY App and redirect back after payment completed.',
              textAlign: TextAlign.center,
              style: kPaymentMethodDescriptionTextStyle)
        ],
      ),
    );
  }
}
