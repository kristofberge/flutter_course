import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {'name': null, 'description': null, 'price': null, 'image': 'assets/food.jpg'};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Constants get _constants => Constants.of(context);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return model.selectedProductIndex == null
          ? _buildPageContent()
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
              ),
              body: _buildPageContent(product: model.selectedProduct),
            );
    });
  }

  GestureDetector _buildPageContent({Product product}) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650 ? 600 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: targetWidth,
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding),
            children: <Widget>[
              _buildNameTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 16.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.title,
      decoration: InputDecoration(
        labelText: 'Name',
        icon: Icon(Icons.edit),
      ),
      onSaved: (text) {
        _formData[_constants.nameKey] = text;
      },
      validator: (String text) => _validateTextField(text, 'Name', minLength: 5),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.description,
      decoration: InputDecoration(
        labelText: 'Description',
        icon: Icon(Icons.description),
      ),
      maxLines: 4,
      onSaved: (text) {
        _formData[_constants.descriptionKey] = text;
      },
      validator: (String text) => _validateTextField(text, 'Description', minLength: 10),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.price.toString(),
      decoration: InputDecoration(
        labelText: 'Price',
        icon: Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (text) {
        _formData[_constants.priceKey] = double.parse(text.replaceFirst(new RegExp(','), '.'));
      },
      validator: (String text) => _validateTextField(text, 'Price', regex: RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$')),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RaisedButton(
          textColor: Colors.white,
          child: Text('Save'),
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectedProductIndex),
        );
      },
    );
  }

  void _submitForm(Function addProduct, Function updateProduct, [int selectedProductIndex]) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (selectedProductIndex == null) {
        addProduct(_createProduct(_formData));
      } else {
        updateProduct(_createProduct(_formData));
      }
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  String _validateTextField(String value, String name, {int minLength = 0, RegExp regex}) {
    if (value.isEmpty) {
      return '$name is required';
    }
    if (minLength != 0 && value.length < minLength) {
      return '$name should have at least $minLength characters';
    }
    if (regex != null && !regex.hasMatch(value)) {
      return 'Please enter a valid value for $name';
    }

    return null;
  }

  Product _createProduct(Map<String, dynamic> formData) {
    return Product(
      title: formData['name'],
      image: formData['image'],
      description: formData['description'],
      price: formData['price'],
    );
  }
}
