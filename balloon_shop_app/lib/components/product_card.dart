import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.imageUrl,
      required this.price,
      this.onAmountUpdated})
      : super(key: key);
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final void Function(String, int)? onAmountUpdated;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int amount = 0;

  _onAddAmount() {
    setState(() {
      amount = amount + 1;
    });
    widget.onAmountUpdated?.call(widget.id, amount);
  }

  _onSubAmount() {
    if (amount > 0) {
      setState(() {
        amount = amount - 1;
      });
    }
    widget.onAmountUpdated?.call(widget.id, amount);
  }

  @override
  void initState() {
    super.initState();
    amount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(kBorderRadiusCommon),
        ),
        width: 260.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductCover(
              imageUrl: widget.imageUrl,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProductTitle(name: widget.name),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.price,
                        style: kProductPriceTextStyle,
                      ),
                      Text(
                        '฿',
                        style: kProductPriceUnitTextStyle,
                      )
                    ],
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border(
                      top:
                          BorderSide(color: Colors.grey.shade400, width: 1.5))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProductAmountAdjustButton(
                      icon: Icon(Icons.remove),
                      onPressed: _onSubAmount,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: 32,
                        child: Center(
                          child: Text(
                            amount.toString(),
                            style: kProductAmountTextStyle,
                          ),
                        ),
                      ),
                    ),
                    ProductAmountAdjustButton(
                      icon: Icon(Icons.add),
                      onPressed: _onAddAmount,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCover extends StatelessWidget {
  const ProductCover({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              imageUrl,
            )),
        borderRadius: BorderRadius.all(kBorderRadiusCommon),
      ),
      foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54.withOpacity(0.2)]),
          borderRadius: BorderRadius.all(kBorderRadiusCommon)),
    );
  }
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Center(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: kProductTitleTextStyle,
              ),
            )),
      ],
    );
  }
}

class ProductAmountAdjustButton extends StatelessWidget {
  const ProductAmountAdjustButton(
      {Key? key, this.onPressed, required this.icon})
      : super(key: key);
  final VoidCallback? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
            padding: EdgeInsets.all(0),
            onPressed: onPressed,
            icon: IconTheme(
              data: IconThemeData(color: Colors.deepPurple, size: 18),
              child: icon,
            )),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.deepPurple)),
      height: 24,
      width: 24,
    );
  }
}
