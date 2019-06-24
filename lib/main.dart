import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/scoped-models/main.dart';
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
  final _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((isAuthenticated) =>
        setState(() => _isAuthenticated = isAuthenticated));
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

  Route _onUnknownRoute() => MaterialPageRoute(
      builder: (context) =>
          _isAuthenticated ? ProductsListPage(_model) : AuthPage());

  Route _onGeneratedRoute(RouteSettings settings) =>
      _isAuthenticated ? _navigateToDetails(settings) : AuthPage();

  MaterialPageRoute _navigateToDetails(RouteSettings settings) {
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
      '/manage': (context) =>
          _isAuthenticated ? ProductAdminPage(_model) : AuthPage(),
      '/': (context) => ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) =>
                _isAuthenticated ? ProductsListPage(_model) : AuthPage(),
          ),
    };
  }

  ThemeData _buildThemeData() {
    return ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
        buttonColor: Colors.deepPurple);
  }
}
