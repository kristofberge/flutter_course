import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/pages/product_edit_page.dart';
import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProductsPage extends StatefulWidget {
  final MainModel model;

  const MyProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MyProductPageState();
  }
}

class _MyProductPageState extends State<MyProductsPage>{
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.displayedProducts.length == 0
            ? Center(child: Text('No items to display'))
            : ListView.builder(
                itemCount: model.allProducts.length,
                itemBuilder: (context, index) => _buildDismissibleListItem(model, model.allProducts[index], context),
              );
      },
    );
  }

  Widget _buildDismissibleListItem(ProductsModel model, Product product, BuildContext context) {
    return Dismissible(
      key: Key(product.id),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          model.selectProduct(product.id);
          await model.deleteProduct();
        }
      },
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: <Widget>[
          _buildListItemContent(context, product, model),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildListItemContent(BuildContext context, Product product, ProductsModel model) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.image)),
      title: Text(product.title),
      subtitle: Text('\$${product.price}'),
      trailing: _buildEditButton(context, product.id, model),
    );
  }

  Widget _buildEditButton(BuildContext context, String id, ProductsModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(id);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductEditPage();
        })).then((_) => model.selectProduct(null));
      },
    );
  }
}
