import 'package:flutter_course/models/user.dart';
import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  void login(String email, String password) {
    authenticatedUser = User(id: 'asdasda', email: email, password: password);
  }
}
