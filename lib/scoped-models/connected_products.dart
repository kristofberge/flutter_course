import 'dart:async';
import 'dart:convert';

import 'package:flutter_course/common/url_builder.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:flutter_course/pages/auth_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;

  void _endLongOperation() {
    _isLoading = false;
    notifyListeners();
  }

  void _startLongOperation() {
    _isLoading = true;
    notifyListeners();
  }
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts => List.from(_products);

  List<Product> get displayedProducts => _showFavorites
      ? List.from(_products.where((p) => p.isFavorite))
      : List.from(_products);

  String get selectedProductId => _selectedProductId;

  Product get selectedProduct => _selectedProductId == null
      ? null
      : _products.firstWhere((p) => p.id == _selectedProductId);

  bool get displayFavoritesOnly => _showFavorites;

  User get authenticatedUser => _authenticatedUser;

  int get _selProdIndex => _selectedProductId == null
      ? null
      : _products.indexWhere((p) => p.id == _selectedProductId);

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _startLongOperation();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.capetownetc.com/wp-content/uploads/2018/06/Choc_1.jpeg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    bool success = false;
    try {
      http.Response response = await http.post(
          UrlBuilder.getProductsUrl(_authenticatedUser.token),
          body: json.encode(productData));
      return success = response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      print(error);
    } finally {
      _selectedProductId = null;
      _endLongOperation();
    }
    return success;
  }

  Future<bool> deleteProduct() async {
    _startLongOperation();
    String idToDelete = _selectedProductId;
    _products.removeAt(_selProdIndex);
    notifyListeners();
    final response = await http
        .delete(UrlBuilder.getProductUrl(idToDelete, _authenticatedUser.token));
    _selectedProductId = null;
    _endLongOperation();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
    _startLongOperation();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    final response = await http.put(
        UrlBuilder.getProductUrl(_selectedProductId, _authenticatedUser.token),
        body: json.encode(productData));
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: selectedProduct.isFavorite);
    _products[_selProdIndex] = updatedProduct;
    _endLongOperation();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future toggleIsFavorite() async {
    _startLongOperation();
    if (_selectedProductId != null) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          image: selectedProduct.image,
          price: selectedProduct.price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !selectedProduct.isFavorite);
      if (await _updateFavoritesOnApi(updatedProduct)) {
        _products[_selProdIndex] = updatedProduct;
      }
      _endLongOperation();
    }
  }

  void selectProduct(String id) {
    _selectedProductId = id;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<void> fetchProducts({bool onlyForUser = false}) async {
    _startLongOperation();
    final List<Product> fetchedProducts = [];
    var url = UrlBuilder.getProductsUrl(_authenticatedUser.token);
    final response = await http.get(url);
    final Map<String, dynamic> productListData = json.decode(response.body);
    productListData?.forEach((String productId, dynamic value) {
      final Map<String, dynamic> productData = value;
      final product = Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        image: productData['image'],
        userEmail: productData['userEmail'],
        userId: productData['userId'],
        isFavorite: (productData['wishlistUsers'] as Map<String, dynamic>)?.containsKey(_authenticatedUser.id) ?? false
      );
      fetchedProducts.add(product);
    });
    _products = onlyForUser ? fetchedProducts.where((p) => p.userId == _authenticatedUser.id).toList() : fetchedProducts;
    _endLongOperation();
  }

  Future<bool> _updateFavoritesOnApi(Product updatedProduct) async {
    http.Response response;

    var url = UrlBuilder.getWishlistUrl(
        updatedProduct.id, _authenticatedUser.id, _authenticatedUser.token);
    if (updatedProduct.isFavorite) {
      response = await http.put(url, body: json.encode(true));
    } else {
      response = await http.delete(url);
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }
}

mixin UserModel on ConnectedProductsModel {
  static const _tokenKey = 'token';
  static const _idKey = 'id';
  static const _emailKey = 'email';
  static const _successKey = 'success';
  static const _expiresInKey = 'tokenExpiresIn';

  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject => _userSubject;

  Future<Map<String, dynamic>> authenticate(
      String email, String password, AuthMode mode) async {
    _startLongOperation();
    String url = mode == AuthMode.Login
        ? UrlBuilder.getLoginUrl()
        : UrlBuilder.getSignupUrl();
    final http.Response response =
        await _authenticateWithApi(url, email, password);
    Map<String, dynamic> result = _getResult(response);
    if (result[_successKey]) {
      _authenticatedUser =
          User(id: result[_idKey], email: email, token: result[_tokenKey]);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_tokenKey, _authenticatedUser.token);
      prefs.setString(_idKey, _authenticatedUser.id);
      prefs.setString(_emailKey, _authenticatedUser.email);
      var expiryTimeSeconds = int.parse(result[_expiresInKey]);
      // var expiryTimeSeconds = 7;
      setAuthTimeout(expiryTimeSeconds);
      _userSubject.add(true);
      final DateTime expiryTime =
          DateTime.now().add(Duration(seconds: expiryTimeSeconds));
      prefs.setString(_expiresInKey, expiryTime.toIso8601String());
    }

    _endLongOperation();
    return result;
  }

  Future autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String expiryTimeString = prefs.getString(_expiresInKey);
    final String token = prefs.getString(_tokenKey);
    if (token?.isNotEmpty ?? false) {
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(DateTime.now())) {
        _authenticatedUser = null;
        return;
      }
      _authenticatedUser = new User(
          id: prefs.getString(_idKey),
          email: prefs.getString(_emailKey),
          token: token);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  Future logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_emailKey);
    prefs.remove(_idKey);
    prefs.remove(_expiresInKey);
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<http.Response> _authenticateWithApi(
      String url, String email, String password) async {
    return await http.post(
      url,
      body: json.encode(_createAuthData(email, password)),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Map<String, dynamic> _getResult(http.Response response) {
    Map<String, dynamic> body = json.decode(response.body);
    Map<String, dynamic> result;
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        body.containsKey('idToken')) {
      result = {
        _idKey: body['localId'],
        _successKey: true,
        _tokenKey: body['idToken'],
        'tokenExpiresIn': body['expiresIn']
      };
    } else {
      result = {_successKey: false, 'error': body['error']['message']};
    }
    return result;
  }

  Map<String, dynamic> _createAuthData(String email, String password) =>
      {'email': email, 'password': password, 'returnSecureToken': true};
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading => _isLoading;
}
