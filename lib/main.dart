import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/auth_page.dart';
import 'pages/product_page.dart';
import 'pages/products_list_page.dart';
import 'pages/product_admin_page.dart';
// import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintLayerBordersEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(
    Constants(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        theme: _buildThemeData(),
        routes: _buildRoutes(),
        onGenerateRoute: _onGeneratedRoute,
        onUnknownRoute: _onUnknownRoute,
      ),
    );
  }

  Route _onUnknownRoute(RouteSettings settings) => MaterialPageRoute(builder: (context) => ProductsListPage());

  Route _onGeneratedRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '') {
      return null;
    }
    if (pathElements[1] == 'product') {
      final int index = int.parse(pathElements[2]);
      return MaterialPageRoute<bool>(
        builder: (context) => ProductPage(index),
      );
    }
    return null;
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => ProductsListPage(),
      '/manage': (context) => ProductAdminPage(),
      '/': (context) => AuthPage()
    };
  }

  ThemeData _buildThemeData() {
    return ThemeData(primarySwatch: Colors.deepOrange, accentColor: Colors.deepPurple, buttonColor: Colors.deepPurple);
  }
}
