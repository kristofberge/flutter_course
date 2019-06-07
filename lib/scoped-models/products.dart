import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool _showFavorites = false;

  List<Product> get allProducts => List.from(products);

  List<Product> get displayedProducts =>
      _showFavorites ? List.from(products.where((p) => p.isFavorite)) : List.from(products);

  int get selectedProductIndex => selectedProductIndex;

  Product get selectedProduct => selectedProductIndex == null ? null : products[selectedProductIndex];

  bool get displayFavoritesOnly => _showFavorites;



  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    products[selectedProductIndex] = product;
    selectedProductIndex = null;
    notifyListeners();
  }

  void toggleIsFavorite() {
    if (selectedProductIndex != null) {
      final Product updatedProduct = Product(
          title: selectedProduct.title,
          description: selectedProduct.description,
          image: selectedProduct.image,
          price: selectedProduct.price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !selectedProduct.isFavorite);
      updateProduct(updatedProduct);
      selectedProductIndex = null;
      notifyListeners();
    }
  }

  void setSelectProduct(int index) {
    selectedProductIndex = index;
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
