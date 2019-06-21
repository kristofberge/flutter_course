import 'package:flutter/material.dart';
import 'package:flutter_course/common/constants.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController(text: '123456');
  final Map<String, dynamic> _authData = {'email': null, 'password': null, 'terms': true};

  Constants _constants() => Constants.of(context);

  AuthMode _authMode = AuthMode.Login;

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
                    _buildEmailTextField(),
                    SizedBox(height: 10),
                    _buildPasswordTextField(),
                    SizedBox(height: 10),
                    _buildConfirmPasswordTextField(),
                    SizedBox(height: 10),
                    _buildTermsSwitch(),
                    SizedBox(height: 20),
                    FlatButton(
                        child: Text('Switch to ${_authMode == AuthMode.Login ? 'Sign up' : 'Login'}'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                          });
                        }),
                    SizedBox(height: 10),
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

  Widget _buildLoginButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? CircularProgressIndicator()
            : RaisedButton(
                child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: _submitForm);
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password', fillColor: Colors.white, filled: true),
      controller: _passwordTextController,
      onSaved: (text) {
        _authData[_constants().passwordKey] = text;
      },
      obscureText: true,
      validator: (String value) => _validateTextField(value, 'password', minLength: 6),
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return _authMode == AuthMode.Login
        ? Container()
        : TextFormField(
            decoration: InputDecoration(labelText: 'Confirm password', fillColor: Colors.white, filled: true),
            obscureText: true,
            validator: (String value) {
              if (value != _passwordTextController.text) {
                return 'please enter matching passwords';
              }
              return null;
            },
          );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email', fillColor: Colors.white, filled: true),
      initialValue: 'test@test.tst',
      onSaved: (text) {
        _authData[_constants().emailKey] = text;
      },
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

  void _validateAndContinue() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var model = ScopedModel.of<MainModel>(context);
      final Map<String, dynamic> result = await model.authenticate(_authData['email'], _authData['password'], _authMode);
      if (result['success']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showAuthenticationErrorDialog(context, result['error']);
      }
    }
  }

  void _showAuthenticationErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Authentication failed'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
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
