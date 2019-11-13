import 'package:flutter/material.dart';

class AddDrink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add drink'),
      ),
      body: GridView.count(
        padding: EdgeInsets.symmetric(vertical: 26),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        childAspectRatio: 5 / 4,

        // Generate 100 widgets that display their index in the List.
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/beer.png',
                  width: 100,
                ),
                Text(
                  'Beer',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
          ),
          addCustomDrink(),
        ],
      ),
    );
  }

  Widget addCustomDrink() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Icon(
                  Icons.add,
                  size: 50,
                ),
              ),
              Text('Add a custom drink')
            ],
          ),
        ),
      ),
    );
  }
}
