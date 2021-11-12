import 'package:balloon_shop_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class AppBackgroundContainer extends StatelessWidget {
  const AppBackgroundContainer({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: child,
        decoration: const BoxDecoration(
          gradient: kAppBackgroundColor,
        ));
  }
}
