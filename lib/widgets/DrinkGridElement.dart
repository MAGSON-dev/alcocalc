import 'package:flutter/material.dart';

class DrinkGridElement extends StatelessWidget {
  final Map drink;

  DrinkGridElement({@required this.drink});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset(
            drink['img'],
            width: 100,
          ),
          Text(
            (drink['quantity'] > 1 ? drink['quantity'].toString() + 'x ' : '') +
                drink['name'],
            style: Theme.of(context).textTheme.headline,
          ),
        ],
      ),
    );
  }
}
