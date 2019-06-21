import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/logout_list_tile.dart';
import 'package:flutter_course/widgets/products_list.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsListPage extends StatefulWidget {
  final MainModel model;

  const ProductsListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return ProductsListState();
  }
}

class ProductsListState extends State<ProductsListPage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage products'),
              onTap: () => Navigator.pushReplacementNamed(context, '/manage'),
            ),
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly ? Icons.favorite : Icons.favorite_border),
                color: Colors.white,
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          ),
        ],
      ),
      body: _buildProductsList(),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          return RefreshIndicator(
            child: ProductsList(),
            onRefresh: () async => await model.fetchProducts(),
          );
        } else if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(child: Text('No products to diplay'));
      },
    );
  }
}
