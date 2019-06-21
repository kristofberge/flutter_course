import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'product_list_item.dart';

class ProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: (context, index) =>
            ProductListItem(product: products[index]),
        itemCount: products.length,
      );
    } else {
      return Center(child: Text('PUSH THE BUTTON!!!'));
    }
  }
}
