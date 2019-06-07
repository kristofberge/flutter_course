import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final String name;

  const ProductName(this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontFamily: 'Oswald',
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 1),
    );
  }
}
