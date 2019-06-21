import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/logout_list_tile.dart';
import './my_products_page.dart';
import './product_edit_page.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;

  ProductAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'My Products',
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: _buildMenu(context),
        ),
        body: TabBarView(
          children: [
            ProductEditPage(),
            MyProductsPage(model)
          ],
        ),
      ),
    );
  }

  Column _buildMenu(BuildContext context) {
    return Column(
          children: [
            AppBar(
              title: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            Divider(),
            LogoutListTile(),
          ],
        );
  }
}
