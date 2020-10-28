import 'package:flutter/material.dart';
import 'package:timer_with_dices/Utils/time.dart';
import 'package:timer_with_dices/database/dbSettings.dart';
import 'package:timer_with_dices/models/settingsModel.dart';

class DialogWithTextField extends StatefulWidget {
  final int timer;
  final int dices;
  final String theme;
  final int id;
  DialogWithTextField({Key key, this.id, this.timer, this.dices, this.theme}) : super(key: key);

  @override
  _DialogWithTextFieldState createState() => _DialogWithTextFieldState();
}

class _DialogWithTextFieldState extends State<DialogWithTextField> {
  final configNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    configNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 24),
          Text(
            "Save configuration",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
              child: TextFormField(
                controller: configNameController,
                maxLines: 1,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Enter name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              )),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 8),
              RaisedButton(
                color: Colors.white,
                child: Text(
                  "Save".toUpperCase(),
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  _save(configNameController.text, widget.id, widget.dices, widget.timer, widget.theme);
                  return Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

_save(String configName, int cnt, int dices, int timer, String theme) async {
  var currentTimeInSecs = TimeUtil.currentTimeInSeconds();
  print(currentTimeInSecs.toString());
  Settings setting =
      Settings(configname: configName, dices: dices, timer: timer, theme: theme, currdatetime: currentTimeInSecs);
  DatabaseSettings helper = DatabaseSettings.instance;
  int id = await helper.insert(setting);
  print('inserted row: $id');
}
