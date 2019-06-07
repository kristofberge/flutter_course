import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/details_subtitle.dart';
import 'package:flutter_course/widgets/product_name.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int index;

  ProductPage(this.index);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          final Product product = model.products[index];
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            body: Center(
              child: Column(children: [
                _buildImage(product.image),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ProductName(product.title),
                ),
                _buildSubtitle('Union Square, San Francisco', product.price),
                _buildDescription(product.description),
              ]),
            ),
          );
        },
      ),
    );
  }

  SingleChildScrollView _buildDescription(String description) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 14),
      child: Text(
        description,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Row _buildSubtitle(String location, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DetailsSubtitle(location),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        DetailsSubtitle('\$$price'),
      ],
    );
  }

  Padding _buildImage(String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 6.0,
        child: Image.asset(image),
      ),
    );
  }
}
