import 'package:flutter/material.dart';

class DrinkGridElementForAddPage extends StatelessWidget {
  final Map drink;

  DrinkGridElementForAddPage({@required this.drink});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            drink['img'],
            width: 100,
          ),
          Text(drink['name'], style: Theme.of(context).textTheme.headline),
        ],
      ),
    );
  }
}
