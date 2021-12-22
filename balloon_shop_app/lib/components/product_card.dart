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
          borderRadius: BorderRadius.all(kDefaultComponentRadius),
        ),
        width: 260.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductCover(
              imageUrl: widget.imageUrl,
            ),
            ProductTitle(name: widget.name),
            Container(color: Colors.grey, child: Text(widget.price)),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProductAmountAdjustButton(
                    icon: Icon(Icons.remove),
                    onPressed: _onSubAmount,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      amount.toString(),
                      style: TextStyle(
                          color: Colors.deepPurple.shade800, fontSize: 26.0),
                    ),
                  ),
                  ProductAmountAdjustButton(
                    icon: Icon(Icons.add),
                    onPressed: _onAddAmount,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductTitle extends StatelessWidget {
  const ProductTitle({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 14.0),
                child: Center(
                  child: Text(
                    name,
                    overflow: TextOverflow.fade,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              )),
        ],
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
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              imageUrl,
            )),
        borderRadius: BorderRadius.all(kDefaultComponentRadius),
      ),
      foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54.withOpacity(0.2)]),
          borderRadius: BorderRadius.all(kDefaultComponentRadius)),
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
