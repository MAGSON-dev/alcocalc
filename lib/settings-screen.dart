import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController(text: '70');

  SettingScreen() {
    load().then((value) {
      if (value != null) {
        controller.text = value.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: new InputDecoration(
                    labelText: 'Weight',
                    hintText: 'Please enter weight to calculate BAC',
                    labelStyle: TextStyle(fontSize: 20)),
                style: TextStyle(fontSize: 20),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter weight';
                  }
                },
                onChanged: (String weight) {
                  print(weight);
                  save(int.parse(weight));
                }),
          ],
        ),
      ),
    );
  }

  Future<int> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
	int weight = prefs.getInt('weight');
    return weight;
  }

  save(int weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('weight', weight);
  }
}
