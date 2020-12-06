import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_with_dices/Utils/time.dart';
import 'package:timer_with_dices/statefulwidgets/loadStatesWindow.dart';
import 'package:timer_with_dices/statefulwidgets/saveStatesWindow.dart';
import 'Action.dart';
import "package:timer_with_dices/models/settingsModel.dart";
import "package:timer_with_dices/database/dbSettings.dart";
import "ColorManagement.dart";

enum RadiobuttonSelection { red, black, community }
Color currThemeColor = AppColors.PRIMARY_COLOR_RED;

void main() async {
  //Brightness brightness;
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //brightness = Brightness.dark;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new MyHomePage(
          title: 'Timer & Dice(s)',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseSettings helper = DatabaseSettings.instance;
  int dbCntr = 1;
  double _currentSliderValueDice;
  double _currentSliderValueTimer;
  double _currentSliderValueTimerMax = 3600;
  double _currentSliderValueTimerParam;
  String timerText;
  String settingsTemplateNameText;
  String textDice;
  String lastSettingStr = 'lastSetting';
  RadiobuttonSelection _character = RadiobuttonSelection.red;

  var textControllerTimer = new TextEditingController();

  void onSliderChangeTimer(double value) {
    _currentSliderValueTimer = value;
    textControllerTimer.text = value.round().toString(); //Timer TextEdit
    settingsTemplateNameText = "";
    SetTimerText(value);
    updateLastSetting(_currentSliderValueTimer, _currentSliderValueDice);
  }

  void onSliderChangeDice(double value) {
    _currentSliderValueDice = value;
    textDice = "Dice(s): " + value.round().toString();
    settingsTemplateNameText = "";
    updateLastSetting(_currentSliderValueTimer, _currentSliderValueDice);
  }

  void clear() {
    timerText = "No timer set";
    textDice = "No dices selected";
    textControllerTimer.text = ""; //Timer TextEdit
    _currentSliderValueTimer = 0;
    _currentSliderValueDice = 0;
    settingsTemplateNameText = "";
    updateLastSetting(_currentSliderValueTimer, _currentSliderValueDice);
  }

  void updateLastSetting(double timer, double dices) {
    Settings setting =
        Settings(configname: lastSettingStr, timer: timer.toInt(), dices: dices.toInt(), theme: 'bright');
    helper.insert(setting);
  }

  @override
  void initState() {
    _getLastUsedTemplate();
    super.initState();
  }

  _getLastUsedTemplate() async {
    SetSettings(60, 2, "");
    await helper.readSingle(lastSettingStr).then((value){
      setState(() {
        if(value == null){
          SetSettings(60, 2, "");
        }
        else{
          SetSettings(value.timer, value.dices, "");
        }
        Settings lastUsedSetting = value;
      });
    });
  }

  void SetSettings(int timer, int dices, String template) {
    SetTimerText(timer.toDouble());
    textControllerTimer.text = timer.toInt().toString();
    textDice = "Dice(s): " + dices.toInt().toString();
    _currentSliderValueDice = dices.toDouble();
    settingsTemplateNameText = template;
  }

  void SetTimerText(double value) {
    int hr = 0;
    int min = 0;
    int sec = 0;
    int rem;

    if (value >= 3600) {
      hr = (value / 3600).floor();
      rem = value.round() - (hr * 3600);
      if (rem > 60) {
        min = (rem / 60).floor();
        sec = rem - min;
      }
      sec = (value - (hr * 3600 + min * 60)).round();
    } else if (value >= 60) {
      min = (value / 60).floor();
      sec = value.round() - (min * 60);
    } else {
      sec = value.round();
    }

    timerText = "Timer: " + hr.toString() + "h " + min.toString() + "min " + sec.toString() + "s ";
    _currentSliderValueTimerParam = value;
    _currentSliderValueTimer = (value > _currentSliderValueTimerMax) ? _currentSliderValueTimerMax : value;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Row(
            children: [
              Text(widget.title),
              Radio(
                value: RadiobuttonSelection.red,
                groupValue: _character,
                onChanged: (RadiobuttonSelection value) {
                  setState(() {
                    _changeTheme(value);
                    _character = value;
                  });
                },
              ),
              Radio(
                value: RadiobuttonSelection.black,
                groupValue: _character,
                onChanged: (RadiobuttonSelection value) {
                  setState(() {
                    _changeTheme(value);
                    _character = value; });
                },),
              Radio(
                value: RadiobuttonSelection.community,
                groupValue: _character,
                onChanged: (RadiobuttonSelection value) {
                  setState(() {
                    _changeTheme(value);
                    _character = value; });
                },)
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                Text(timerText, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Slider(
                  value: _currentSliderValueTimer,
                  min: 0,
                  max: _currentSliderValueTimerMax,
                  divisions: 360,
                  label: _currentSliderValueTimer.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      onSliderChangeTimer(value);
                    });
                  },
                ),
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(right: 80, left: 80),
                    child: TextField(
                      controller: textControllerTimer,
                      onChanged: (text) {
                        setState(() {
                          SetTimerText(double.parse(text));
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter timer in seconds (leave empty for no timer)',
                      ),
                    )),
                const SizedBox(width: 30),
                const SizedBox(height: 40),
                Text(textDice, style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _currentSliderValueDice,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _currentSliderValueDice.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      onSliderChangeDice(value);
                    });
                  },
                ),
                const SizedBox(height: 40),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ButtonTheme(
                      buttonColor: Colors.deepOrangeAccent,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            clear();
                          });
                        },
                        child: const Text('CLEAR', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ButtonTheme(
                      buttonColor: Colors.deepOrangeAccent,
                      child: RaisedButton(
                        onPressed: () {
                          _showLoadStates();
                        },
                        child: const Text('LOAD', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 40),
                    ButtonTheme(
                      buttonColor: Colors.deepOrangeAccent,
                      child: RaisedButton(
                        onPressed: () {
                          _saveStates();
                        },
                        child: const Text('SAVE', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ButtonTheme(
                  minWidth: 200.0,
                  buttonColor: Colors.deepOrange,
                  textTheme: ButtonTextTheme.accent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActionRoute(
                                  timer: _currentSliderValueTimerParam,
                                  dices: _currentSliderValueDice,
                                )),
                      );
                    },
                    child: const Text(
                      'START',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Selected template: ",
                      style: new TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    new Text(settingsTemplateNameText, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _changeTheme(RadiobuttonSelection themeColor){

    switch(themeColor) {
      case RadiobuttonSelection.red:{
        currThemeColor = AppColors.PRIMARY_COLOR_RED;
      }
      break;
      case RadiobuttonSelection.black:{
        currThemeColor = AppColors.PRIMARY_COLOR_DARK;
      }
      break;
      case RadiobuttonSelection.community:{
        currThemeColor = AppColors.PRIMARY_COLOR_LIGHT;
      }
      break;


    }
  }

  void _showLoadStates() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Saved configurations'),
            content: LoadStates(notifyParent: this.refreshSettings),
          );
        });
  }

  void _saveStates() {
    int timer = _currentSliderValueTimerParam.toInt();
    int dices = _currentSliderValueDice.toInt();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: DialogWithTextField(
              timer: timer,
              dices: dices,
              theme: "bright",
            ),
          );
        });
  }

  refreshSettings(double timer, double dices, String template) {
    setState(() {
      SetSettings(timer.toInt(), dices.toInt(), template);
    });
  }

  _updateDbCntr() async {
    DatabaseSettings helper = DatabaseSettings.instance;
    dbCntr = await helper.getRowsCnt() + 1;
    return dbCntr;
  }
}
