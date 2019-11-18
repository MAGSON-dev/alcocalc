import 'dart:convert';

import 'package:Alcocalc/widgets/DrinkGridElement.dart';
import 'package:Alcocalc/widgets/DrinkGridElementForAddPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDrink extends StatefulWidget {
  @override
  _AddDrinkState createState() => _AddDrinkState();
}

class _AddDrinkState extends State<AddDrink> {
  List<Map> drinks = [
    {
      'name': 'Beer',
      'alcoholPercentage': 4.7,
      'size': 5,
      'quantity': 1,
      'img': 'assets/beer.png'
    },
    {
      'name': 'Vodka',
      'alcoholPercentage': 40,
      'size': 0.044,
      'quantity': 1,
      'img': 'assets/shot.jpg'
    },
    {
      'name': 'Bottle of wine',
      'alcoholPercentage': 12,
      'size': 7.5,
      'quantity': 1,
      'img': 'assets/wine.png'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add drink'),
        ),
        body: GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 26),
          itemCount: drinks.length + 1,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, idx) {
            if (idx < drinks.length) {
              return InkWell(
                child: DrinkGridElementForAddPage(drink: drinks[idx]),
                onTap: () {
                  print(drinks[idx]['name']);
                  addDrink(drinks[idx]).then((_) {
                    Navigator.pop(context);
                  });
                },
              );
            }
            return addCustomDrink();
          },
        ));
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
              Text('Create a custom drink')
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> addDrink(Map drink) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load previous drinks
    String x = prefs.getString('consumedDrinks');
    List<Map> drinks;

    if (x != null) {
      drinks = List<Map>.from(json.decode(x));
    } else {drinks = [];
    }

    // Add new drink
    drinks.add(drink);

    if (drinks.length == 1) {
      prefs.setString('startDrinkingTime', DateTime.now().toIso8601String());
    }

    // Save
    return prefs.setString('consumedDrinks', json.encode(drinks));
  }
}
