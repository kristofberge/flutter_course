import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget{
  final String text;
  final EdgeInsets padding;

  const AddressTag({Key key, this.text, this.padding = const EdgeInsets.all(0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            child: Text(text),
            padding: padding,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5)),
          );
  }
  
}