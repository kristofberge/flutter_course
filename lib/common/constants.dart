import 'package:flutter/material.dart';

class Constants extends InheritedWidget {
  static Constants of(BuildContext context) => context.inheritFromWidgetOfExactType(Constants);

  const Constants({Widget child, Key key}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  final String nameKey = 'name';
  final String descriptionKey = 'description';
  final String imageKey = 'image';
  final String priceKey = 'price';
  final String passwordKey = 'password';
  final String emailKey = 'email';
  final String termsKey = 'terms';
}
