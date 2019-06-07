import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/products_list.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsListPage extends StatelessWidget {
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
            )
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
      body: ProductsList(),
    );
  }
}
