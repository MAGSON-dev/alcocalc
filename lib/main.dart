import 'dart:convert';

import 'package:Alcocalc/AddDrink.dart';
import 'package:Alcocalc/settings-screen.dart';
import 'package:Alcocalc/widgets/DrinkGridElement.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/animation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          primaryColorDark: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Map> consumedDrinks = [];
  int weight = 70;
  double totalBAC = 0.0;
  DateTime startDrinkingTime;

  // Expandable appbar
  AnimationController controller;
  Animation<double> animation;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 85, end: 250)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  _animateAppBar() {
    expanded ? controller.reverse() : controller.forward();
    setState(() {});
    expanded = !expanded;
  }

  @override
  Widget build(BuildContext context) {
    loadConsumedDrinks().then((List<Map> value) {
      if (value != null) {
        // Prevent re building if data hasnt changed
        if (value != consumedDrinks)
          setState(() {
            consumedDrinks = value;
          });
      }
    });
    loadWeight().then((int w) {
      if (w != null) {
        if (w != weight)
          setState(() {
            weight = w;
          });
      }
    });
    loadStartDrinkingTime().then((DateTime t) {
      if (t != null) {
        if (t != startDrinkingTime)
          setState(() {
            startDrinkingTime = t;
          });
      }
    });

    totalBAC = 0.0;
    consumedDrinks.forEach((d) {
      totalBAC +=
          d['quantity'] * (d['size'] * d['alcoholPercentage']) / (weight * 0.6);
    });

    Duration durSinceLastDrink;
    double currentBAC = 0.0;
    DateTime soberAt;

    if (startDrinkingTime != null) {
      // THis is called on  null
      durSinceLastDrink = DateTime.now().difference(startDrinkingTime);
      currentBAC = totalBAC - (durSinceLastDrink.inMinutes / 60) * 0.1;
      int minTillSober = ((currentBAC / 0.1) * 60).toInt();
      soberAt = DateTime.now().add(Duration(minutes: minTillSober));
    }

    if (currentBAC < 0) {
      // Reset everything
      reset();
    }

    print(consumedDrinks);
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Alcocalc',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(animation.value),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: animation.value,
                    child: Column(
                      children: <Widget>[
                        Text(
                          currentBAC.toStringAsFixed(2).toString() + '‰',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            totalBAC == 0.0
                                ? 'You are sober'
                                : 'Started drinking ' +
                                    durSinceLastDrink.inMinutes.toString() +
                                    'min ago · Sober at ' +
                                    DateFormat('kk:mm').format(soberAt) +
                                    ' (' +
                                    soberAt
                                        .difference(DateTime.now())
                                        .inHours
                                        .toString() +
                                    'h)',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        _animateAppBar();
                      },
                    ),
                    right: 0,
                    top: 27,
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddDrink()));
            },
          ),
          body: consumedDrinks.length != 0
              ? GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 26),
                  itemCount: consumedDrinks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, idx) {
                    return InkWell(
                      child: DrinkGridElement(drink: consumedDrinks[idx]),
                      onLongPress: () {
                        List<Widget> actions;
                        if (consumedDrinks[idx]['quantity'] > 1) {
                          actions = [
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Delete all'),
                              onPressed: () {
                                deleteDrink(idx).then((_) => setState(() {}));
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Delete one'),
                              onPressed: () {
                                setState(() {
                                  deleteOneDrink(idx);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ];
                        } else {
                          actions = <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                deleteDrink(idx).then((_) => setState(() {}));
                                Navigator.of(context).pop();
                              },
                            ),
                          ];
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text('Delete'),
                                  content: Text(
                                      'Are you sure you want to remove this drink from your consumed drinks?'),
                                  actions: actions);
                            });
                      },
                    );
                  },
                )
              : Stack(
                  children: <Widget>[
                    FlareActor("assets/beer-animation.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        animation: "beer"),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 156.0),
                        child: Text('No drinks added'),
                      ),
                    ),
                  ],
                ),
        ));
  }

  Future<List<Map>> loadConsumedDrinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String x = prefs.getString('consumedDrinks');
    if (x != null) {
      List<Map> drinks = List<Map>.from(json.decode(x));
      return drinks;
    }
    return null;
  }

  Future<int> loadWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int weight = prefs.getInt('weight');
    return weight;
  }

  Future<DateTime> loadStartDrinkingTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String iso = prefs.getString('startDrinkingTime');
    if (iso != null) {
      return DateTime.parse(iso);
    } else
      return null;
  }

  Future reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    consumedDrinks = [];
    prefs.setString('consumedDrinks', json.encode(consumedDrinks));
    startDrinkingTime = null;
    prefs.remove('startDrinkingTime');
  }

  Future<bool> deleteOneDrink(int idx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load previous drinks
    String x = prefs.getString('consumedDrinks');
    List<Map> drinks;

    if (x != null) {
      drinks = List<Map>.from(json.decode(x));
    } else {
      drinks = [];
    }

    // Add new drink
    drinks[idx]['quantity']--;

    // Save
    return prefs.setString('consumedDrinks', json.encode(drinks));
  }

  Future<bool> deleteDrink(int idx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load previous drinks
    String x = prefs.getString('consumedDrinks');
    List<Map> drinks;

    if (x != null) {
      drinks = List<Map>.from(json.decode(x));
    } else {
      drinks = [];
    }

    // Add new drink
    drinks.removeAt(idx);

    // Save
    return prefs.setString('consumedDrinks', json.encode(drinks));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
