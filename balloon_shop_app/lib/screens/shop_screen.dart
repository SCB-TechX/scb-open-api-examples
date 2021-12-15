import 'dart:convert';

import 'package:balloon_shop_app/components/app_background_container.dart';
import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  List<ProductItem> productItems = <ProductItem>[];

  @override
  void initState() {
    super.initState();
    _loadingScreenData();
  }

  void _onCheckoutClick() async {
    http.Response response = await http.post(
        Uri.https(kBalloonShopBackendEndpoint, kUriCreatePaymentDeeplink),
        headers: {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMUBzYW1wbGUuY29tIiwiaWF0IjoxNjM3NzI1Mzk0OTkxfQ.5Fmw4RxXlTk0GdYCECGnldUMVPQdZmaJ7HcCfOmEFk4'
        });
    var checkoutDeeplink = jsonDecode(response.body)['deeplinkUrl'];
    print(checkoutDeeplink);
    if (await canLaunch(checkoutDeeplink)) {
      var launchResult = await launch(checkoutDeeplink);
    } else {
      print('cannot launch');
    }
  }

  void _loadingScreenData() async {
    setState(() {
      showLoadingSpinner = true;
    });
    await _getAccessToken();
    await _getProducts();
    setState(() {
      showLoadingSpinner = false;
    });
  }

  Future<void> _getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = await sharedPreferences.get(kAccessTokenKey).toString();
  }

  Future<void> _getProducts() async {
    print(accessToken);
    productItems.clear();
    http.Response response = await http.get(
        Uri.https(kBalloonShopBackendEndpoint, kUriGetProducts),
        headers: {kHeaderAuthorization: "Bearer $accessToken"});
    products = jsonDecode(response.body);
    products?.forEach((product) {
      final data = product as Map;
      final price = data['price'] as double;

      productItems.add(new ProductItem(
          imageUrl: data['imageUrl'], price: price, name: data['name']));
    });
    print(products);
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
                  child: ListView(children: productItems),
                ),
                Container(
                  height: 150,
                  color: Colors.teal,
                ),
                Container(
                  height: 120,
                  color: Colors.indigo,
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

class ProductItem extends StatelessWidget {
  const ProductItem(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.price})
      : super(key: key);
  final String name;
  final String imageUrl;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(1),
    );
  }
}
