import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: _buildThemeData(),
        routes: _buildRoutes(),
        onGenerateRoute: (settings) => _onGeneratedRoute(settings),
        onUnknownRoute: (_) => _onUnknownRoute(),
      ),
    );
  }

  Route _onUnknownRoute() => MaterialPageRoute(builder: (context) => ProductsListPage(_model));

  Route _onGeneratedRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '') {
      return null;
    }
    var productId = pathElements[2];
    _model.selectProduct(productId);
    return MaterialPageRoute(builder: (context) {
      return ProductPage();
    });
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/home': (context) => ProductsListPage(_model),
      '/manage': (context) => ProductAdminPage(_model),
      '/': (context) => ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) =>
                model.authenticatedUser == null ? AuthPage() : ProductsListPage(_model),
          ),
    };
  }

  ThemeData _buildThemeData() {
    return ThemeData(primarySwatch: Colors.deepOrange, accentColor: Colors.deepPurple, buttonColor: Colors.deepPurple);
  }
}
