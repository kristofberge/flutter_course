import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:flutter_course/scoped-models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel {
  
}