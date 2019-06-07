import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit_page.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class MyProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.products.length == 0
            ? Center(child: Text('No items to display'))
            : ListView.builder(
                itemCount: model.products.length,
                itemBuilder: (context, index) => _buildDismissibleListItem(model, index, context),
              );
      },
    );
  }

  Dismissible _buildDismissibleListItem(ProductsModel model, int index, BuildContext context) {
    return Dismissible(
      key: Key(model.products[index].title),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          model.setSelectProduct(index);
          model.deleteProduct();
        }
      },
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: <Widget>[
          _buildListItemContent(context, index, model),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildListItemContent(BuildContext context, int index, ProductsModel model) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(backgroundImage: AssetImage(model.products[index].image)),
      title: Text(model.products[index].title),
      subtitle: Text('\$${model.products[index].price}'),
      trailing: _buildEditButton(context, index, model),
    );
  }

  Widget _buildEditButton(BuildContext context, int index, ProductsModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.setSelectProduct(index);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductEditPage();
        }));
      },
    );
  }
}
