import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

import 'address_tag.dart';
import 'price_tag.dart';
import 'product_name.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({@required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Column(
        children: [
          FadeInImage(
            image: NetworkImage(product.image),
            placeholder: AssetImage('assets/food.jpg'),
            height: 300,
            fit: BoxFit.cover,
          ),
          _buildTitleSection(),
          AddressTag(text: 'Union Square, San Francisco', padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3)),
          Text(product.userEmail ?? ''),
          _buildButtonSection(context)
        ],
      ),
    );
  }

  ButtonBar _buildButtonSection(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        _buildInfoButton(context),
        _buildFavoriteButton(),
      ],
    );
  }

  Padding _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProductName(product.title),
          SizedBox(width: 8),
          PriceTag(
            product.price.toString(),
          )
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
          icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
          color: Colors.red,
          onPressed: () async {
            model.selectProduct(product.id);
            await model.toggleIsFavorite();
          },
        );
      },
    );
  }

  IconButton _buildInfoButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info),
      color: Theme.of(context).accentColor,
      onPressed: (){
        Navigator.pushNamed(context, '/product/${product.id}');
      },
    );
  }
}
