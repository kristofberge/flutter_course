import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedProductsModel on Model {
  List<Product> products = [];
  User authenticatedUser;
  int selectedProductIndex;

  void addProduct(String title, String description, String image, double price) {
    final product = Product(
      title: title,
      description: description,
      image: image,
      price: price,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id
    );
    products.add(product);
    selectedProductIndex = null;
    notifyListeners();
  }
}
