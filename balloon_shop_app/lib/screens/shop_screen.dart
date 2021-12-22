import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/components/product_card.dart';
import 'package:balloon_shop_app/screens/qr_code_screen.dart';
import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int paymentType = 0; //0 - QR, 1 - Deeplink

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
      if (paymentType == 1) {
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
        print(response.body);
        var qrImage = jsonDecode(response.body)['qrImage'];
        var qrcodeId = jsonDecode(response.body)['qrcodeId'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QrCodeScreen(
                      qrImage: qrImage,
                      qrId: qrcodeId,
                    )));
      }
    } finally {
      setState(() {
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

  void _onPaymentTypeUpdated(int type) {
    setState(() {
      paymentType = type;
    });
    print(paymentType);
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

  @override
  Widget build(BuildContext context) {
    return AppBackgroundContainer(
        child: ModalProgressHUD(
      inAsyncCall: showLoadingSpinner,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("BALLOON SHOP",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    fontFamily: 'Sen',
                    letterSpacing: 2.0)),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _getProducts,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products != null ? products!.length : 0,
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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(kDefaultComponentRadius)),
                  height: 100,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    totalPrice.toStringAsFixed(2),
                    style: TextStyle(color: Colors.purple, fontSize: 30.0),
                  )),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(kDefaultComponentRadius)),
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.purple,
                        child: TextButton(
                          child: Text(
                            'QR',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                          onPressed: () {
                            _onPaymentTypeUpdated(0);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.purple,
                        child: TextButton(
                          child: Text(
                            'EASY',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                          onPressed: () {
                            _onPaymentTypeUpdated(1);
                          },
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
          )),
    ));
  }
}
