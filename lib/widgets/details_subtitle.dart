import 'package:flutter/material.dart';

class DetailsSubtitle extends StatelessWidget {
  final String text;

  const DetailsSubtitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
    );
  }
}
