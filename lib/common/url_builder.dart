class UrlBuilder {
  static const _apiKey = 'AIzaSyAcZdsKce94sEo8K5ixdKTHi3yyF9yQdpI';

  static const _productsUrl = 'https://fluttercourse-af511.firebaseio.com/products.json';
  static const _signupUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser';
  static const _loginUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword';
  static const _productUrl = 'https://fluttercourse-af511.firebaseio.com/products';

  static const _authProperty = 'auth';
  static const _keyProperty = 'key';

  static const _dotjson = '.json';

  static String getProductsUrl(String token) {
    final StringBuffer buffer = StringBuffer(_productsUrl);
    buffer.writeAll({'?', _authProperty, '=', token});
    return buffer.toString();
  }

  static String getLoginUrl() {
    final StringBuffer buffer = StringBuffer(_loginUrl);
    buffer.writeAll({'?', _keyProperty, '=', _apiKey});
    return buffer.toString();
  }

  static String getSignupUrl() {
    final StringBuffer buffer = StringBuffer(_signupUrl);
    buffer.writeAll({'?', _keyProperty, '=', _apiKey});
    return buffer.toString();
  }

  static String getProductUrl(String id, String token) {
    final StringBuffer buffer = StringBuffer(_productUrl);
    buffer.writeAll({'/', id, _dotjson});
    buffer.writeAll({'?', _authProperty, '=', token});

    return buffer.toString();
  }
}
