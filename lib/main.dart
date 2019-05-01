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

class _Data {
  double units;
  double amount;
  double percent;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _Data _data = new _Data();
  double amountUnits;

  void calculate() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      amountUnits = (_data.amount * _data.units * _data.percent / 100) / 0.235;
      setState(() {});
    }
  }

  Widget buildForm() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: new InputDecoration(
                      labelText: 'Enheter',
                      hintText: 'Antall enheter',
                      labelStyle: TextStyle(fontSize: 20)),
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Skriv inn antall enheter';
                    }
                  },
                  onSaved: (String value) {
                    print(double.parse(value.replaceAll(',', '.')));
                    this._data.units = double.parse(value.replaceAll(',', '.'));
                  }),
              TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: new InputDecoration(
                      labelText: 'Desiliter',
                      hintText: 'Antall desiliter',
                      labelStyle: TextStyle(fontSize: 20)),
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Skriv inn antall desiliter';
                    }
                  },
                  onSaved: (String value) {
                    print(double.parse(value.replaceAll(',', '.')));
                    this._data.amount =
                        double.parse(value.replaceAll(',', '.'));
                  }),
              TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: new InputDecoration(
                      labelText: 'Prosent',
                      hintText: 'Prosent alkohol per enhet',
                      labelStyle: TextStyle(fontSize: 20)),
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Skriv inn mengden alkohol';
                    }
                  },
                  onSaved: (String value) {
                    print(double.parse(value.replaceAll(',', '.')));
                    this._data.percent =
                        double.parse(value.replaceAll(',', '.'));
                  }),
              Container(
                  margin: EdgeInsets.only(top: 28),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: this.calculate,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 23.0),
                    textColor: Colors.white,
                    color: Colors.tealAccent,
                    child: const Text(
                      'Regn ut',
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  )),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Alcocalc',
              ),
            ),
            body: Column(
              children: <Widget>[
                buildForm(),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Text(
                      this.amountUnits != null
                          ? '${this.amountUnits.toStringAsFixed(1)} halvlitere (4,7%)'
                          : '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                )
              ],
            )));
  }
}
