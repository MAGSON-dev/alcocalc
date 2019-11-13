import 'package:Alcocalc/AddDrink.dart';
import 'package:Alcocalc/settings-screen.dart';
import 'package:Alcocalc/widgets/DrinkGridElement.dart';
import 'package:flutter/material.dart';

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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              preferredSize: Size.fromHeight(70.0),
              child: Container(
                height: 70,
                child: Column(
                  children: <Widget>[
                    Text(
                      '2,1',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Last drink 10 min ago · Sober at 10:00',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
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
          body: GridView.count(
            padding: EdgeInsets.symmetric(vertical: 26),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 5 / 4,
            children: <Widget>[
              DrinkGridElement(name: 'Beer', src: 'assets/beer.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/champagne.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/drink.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/shot.jpg'),
              DrinkGridElement(name: 'Beer', src: 'assets/vodka.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/wine.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/beer.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/beer.png'),
              DrinkGridElement(name: 'Beer', src: 'assets/beer.png'),
            ],
          ),
        ));
  }
}
