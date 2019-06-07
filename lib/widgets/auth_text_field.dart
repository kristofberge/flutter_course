import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final Function onSavedFunction;
  final FormFieldValidator<String> validator;
  final String placeholder;
  final TextInputType keyboardType;
  final bool isPassword;
  final String initualValue;

  const AuthTextField(
      {@required this.onSavedFunction,
      this.validator,
      this.placeholder,
      this.initualValue,
      this.keyboardType = TextInputType.text,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return placeholder != null ? _buildTextFieldWithPlaceholder() : _buildTextFieldWithoutPlaceholder();
  }

  Widget _buildTextFieldWithoutPlaceholder() {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(fillColor: Colors.white, filled: true),
      onSaved: onSavedFunction,
      validator: validator,
      initialValue: initualValue,
    );
  }

  Widget _buildTextFieldWithPlaceholder() {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: placeholder, fillColor: Colors.white, filled: true),
      onSaved: onSavedFunction,
      validator: validator,
      initialValue: initualValue,
    );
  }
}
