import 'package:flutter/material.dart';

class DrinkGridElement extends StatelessWidget {

  final String src;
  final String name;

  DrinkGridElement({@required this.src, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            src,
            width: 100,
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.headline,
          ),
        ],
      ),
    );
  }
}
