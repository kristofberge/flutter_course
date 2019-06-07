import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/auth_text_field.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _authData = {'email': null, 'password': null, 'terms': true};

  Constants _constants() => Constants.of(context);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  children: [
                    _buildUsernameTextField(),
                    SizedBox(height: 10),
                    _buildPasswordTextField(),
                    SizedBox(height: 10),
                    _buildTermsSwitch(),
                    SizedBox(height: 20),
                    _buildLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      image: AssetImage('assets/background.jpg'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
    );
  }

  SwitchListTile _buildTermsSwitch() {
    return SwitchListTile(
      title: Text('Accept Terms'),
      value: _authData[_constants().termsKey],
      onChanged: (bool value) {
        setState(() {
          _authData[_constants().termsKey] = value;
        });
      },
    );
  }

  RaisedButton _buildLoginButton(BuildContext context) {
    return RaisedButton(
        child: Text('LOGIN'), color: Theme.of(context).primaryColor, textColor: Colors.white, onPressed: _submitForm);
  }

  Widget _buildPasswordTextField() {
    return AuthTextField(
      initualValue: '12345',
      onSavedFunction: (text) {
        _authData[_constants().passwordKey] = text;
      },
      placeholder: 'password',
      isPassword: true,
      validator: (String value) => _validateTextField(value, 'password', minLength: 5),
    );
  }

  AuthTextField _buildUsernameTextField() {
    return AuthTextField(
      initualValue: 'test@test.tst',
      onSavedFunction: (text) {
        _authData[_constants().emailKey] = text;
      },
      placeholder: 'email',
      keyboardType: TextInputType.emailAddress,
      validator: (String value) => _validateTextField(value, 'email',
          minLength: 4,
          regex: RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")),
    );
  }

  void _submitForm() {
    if (_authData[_constants().termsKey]) {
      _validateAndContinue();
    } else {
      _showTermsDialog();
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Accept terms'),
          content: Text('Please accept the terms before logging in.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _validateAndContinue() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _showLoginConfirmationDialog();
    }
  }

  void _showLoginConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm login.'),
          content: Text('Are you sure want to login with email ${_authData['email']}?'),
          actions: [
            FlatButton(
              child: Text('No, take me back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return FlatButton(
                  child: Text('Yes, go on'),
                  onPressed: () {
                    model.login(_authData['email'], _authData['password']);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                );
              },
            ),
          ],
        );
      },
    );
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
}
