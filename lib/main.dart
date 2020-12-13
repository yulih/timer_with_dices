import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_with_dices/Utils/time.dart';
import 'package:timer_with_dices/models/ThemeEnum.dart';
import 'package:timer_with_dices/statefulwidgets/loadStatesWindow.dart';
import 'package:timer_with_dices/statefulwidgets/saveStatesWindow.dart';
import 'Action.dart';
import "package:timer_with_dices/models/settingsModel.dart";
import "package:timer_with_dices/database/dbSettings.dart";
import 'models/ColorManagement.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

Color globalBackgroundColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalPrimaryColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalUnSelectedBackgroundColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalTextFontColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalSliderColor = AppColors.PRIMARY_COLOR_WHITE;
Color startButtonColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalButtonColor = AppColors.PRIMARY_COLOR_WHITE;
Color globalButtonFontColor = AppColors.PRIMARY_COLOR_WHITE;
Color startButtonFontColor = AppColors.PRIMARY_COLOR_WHITE;
String globalTheme;

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
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                brightness: Brightness.dark,
                backgroundColor: globalBackgroundColor,
                primaryColor: globalPrimaryColor,
                unselectedWidgetColor: globalUnSelectedBackgroundColor),
            home: new MyHomePage(title: 'Timer with dices'),
          );
        });

    MaterialApp(
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
  String lastSettingStr = 'auto-saved template';
  ThemeEnum _currentRadioButtonValue = ThemeEnum.orange;

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
    Settings setting = Settings(
        templateName: lastSettingStr,
        timer: timer.toInt(),
        dices: dices.toInt(),
        theme: globalTheme);
    helper.insert(setting);
  }

  @override
  void initState() {
    _getLastUsedTemplate();
    super.initState();
  }

  _getLastUsedTemplate() async {
    SetSettings(60, 2, "default", "orange");
    await helper.readSingle('fifth').then((value) {
      setState(() {
        if (value == null) {
          SetSettings(61, 2, "default", "orange");
        } else {
          SetSettings(value.timer, value.dices, value.templateName, value.theme);
        }
        //Settings lastUsedSetting = value;
      });
    });
  }

  void SetSettings(int timer, int dices, String template, String theme) {
    SetTimerText(timer.toDouble());
    textControllerTimer.text = timer.toInt().toString();
    textDice = "Dice(s): " + dices.toInt().toString();
    _currentSliderValueDice = dices.toDouble();
    settingsTemplateNameText = template;
    switch(theme) {
      case "orange":
        _currentRadioButtonValue = ThemeEnum.orange;
        _changeTheme(ThemeEnum.orange);
        break;
      case "black":
        _currentRadioButtonValue = ThemeEnum.black;
        _changeTheme(ThemeEnum.black);
        break;
      case "community":
        _currentRadioButtonValue = ThemeEnum.community;
        _changeTheme(ThemeEnum.community);
        break;
      default:
        _currentRadioButtonValue = ThemeEnum.orange;
        _changeTheme(ThemeEnum.orange);
        break;
    }
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

    timerText = "Timer: " +
        hr.toString() +
        "h " +
        min.toString() +
        "min " +
        sec.toString() +
        "s ";
    _currentSliderValueTimerParam = value;
    _currentSliderValueTimer = (value > _currentSliderValueTimerMax)
        ? _currentSliderValueTimerMax
        : value;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
            new FocusNode()); //remove focuscontent
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Row(
              children: [
                Expanded(flex: 2, child: Text(widget.title)),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.amber,
                        value: ThemeEnum.orange,
                        groupValue: _currentRadioButtonValue,
                        onChanged: (ThemeEnum value) {
                          setState(() {
                            _changeTheme(value);
                            _currentRadioButtonValue = value;
                            globalTheme = "orange";
                          });
                        },
                      ),
                      Radio(
                        activeColor: Colors.greenAccent,
                        value: ThemeEnum.black,
                        groupValue: _currentRadioButtonValue,
                        onChanged: (ThemeEnum value) {
                          setState(() {
                            _changeTheme(value);
                            _currentRadioButtonValue = value;
                            globalTheme = "black";
                          });
                        },
                      ),
                      Radio(
                        activeColor: startButtonColor,
                        value: ThemeEnum.community,
                        groupValue: _currentRadioButtonValue,
                        onChanged: (ThemeEnum value) {
                          setState(() {
                            _changeTheme(value);
                            _currentRadioButtonValue = value;
                            globalTheme = "community";
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Text(timerText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: globalTextFontColor)),
                  const SizedBox(height: 10),
                  Slider(
                    activeColor: globalSliderColor,
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
                        style: TextStyle(color: globalTextFontColor),
                        controller: textControllerTimer,
                        onChanged: (text) {
                          setState(() {
                            SetTimerText(double.parse(text));
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: globalSliderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: globalButtonColor),
                            ),
                            labelText: 'Enter seconds (leave blank for no timer)',
                            labelStyle: TextStyle(fontSize: 11, color: globalTextFontColor)),
                      )),
                  const SizedBox(width: 30),
                  const SizedBox(height: 40),
                  Text(textDice,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: globalTextFontColor)),
                  Slider(
                    activeColor: globalSliderColor,
                    value: _currentSliderValueDice,
                    min: 0,
                    max: 6,
                    divisions: 6,
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
                        buttonColor: Theme.of(context).primaryColor,
                        textTheme: ButtonTextTheme.accent,
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(secondary: Colors.white),
                        child: RaisedButton(
                          color: globalButtonColor,
                          onPressed: () {
                            setState(() {
                              clear();
                            });
                          },
                          child: Text('CLEAR',
                              style: TextStyle(
                                  fontSize: 20, color: globalButtonFontColor)),
                        ),
                      ),
                      const SizedBox(width: 40),
                      ButtonTheme(
                        buttonColor: Theme.of(context).primaryColor,
                        textTheme: ButtonTextTheme.accent,
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(secondary: Colors.white),
                        child: RaisedButton(
                          color: globalButtonColor,
                          onPressed: () {
                            _showLoadStates();
                          },
                          child: Text('LOAD',
                              style: TextStyle(
                                  fontSize: 20, color: globalButtonFontColor)),
                        ),
                      ),
                      const SizedBox(width: 40),
                      ButtonTheme(
                        buttonColor: Theme.of(context).primaryColor,
                        textTheme: ButtonTextTheme.accent,
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(secondary: Colors.white),
                        child: RaisedButton(
                          color: globalButtonColor,
                          onPressed: () {
                            _saveStates();
                          },
                          child: Text('SAVE',
                              style: TextStyle(
                                  fontSize: 20, color: globalButtonFontColor)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ButtonTheme(
                    minWidth: 200.0,
                    buttonColor: startButtonColor,
                    textTheme: ButtonTextTheme.accent,
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(secondary: Colors.white),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActionRoute(
                                    timer: _currentSliderValueTimerParam,
                                    dices: _currentSliderValueDice,
                                globalTheme: _currentRadioButtonValue,
                                  )),
                        );
                      },
                      child: Text(
                        'START',
                        style: TextStyle(fontSize: 20, color: startButtonFontColor),
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
                          color: globalTextFontColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      new Text(settingsTemplateNameText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: globalTextFontColor)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _changeTheme(ThemeEnum themeColor) {
    switch (themeColor) {
      case ThemeEnum.orange:
        globalPrimaryColor = AppColors.PRIMARY_COLOR_ORANGE;
        globalBackgroundColor = Colors.white;
        globalSliderColor = AppColors.PRIMARY_COLOR_ORANGE;
        globalTextFontColor = AppColors.PRIMARY_COLOR_BLACK;
        globalButtonFontColor = AppColors.PRIMARY_COLOR_WHITE;
        globalButtonColor = globalPrimaryColor;
        startButtonColor = globalSliderColor;
        startButtonFontColor = globalButtonFontColor;
        DynamicTheme.of(context).setThemeData(new ThemeData(
          primaryColor: AppColors.PRIMARY_COLOR_ORANGE,
        ));
        break;
      case ThemeEnum.black:
          DynamicTheme.of(context).setThemeData(new ThemeData(
            primaryColor: Colors.black,
          ));
        globalPrimaryColor = Colors.black;
        globalBackgroundColor = Colors.black12;
        globalSliderColor = AppColors.PRIMARY_COLOR_DARK_GREEN;
        globalTextFontColor = AppColors.PRIMARY_COLOR_WHITE;
        globalButtonFontColor = AppColors.PRIMARY_COLOR_WHITE;
        globalButtonColor = globalSliderColor;
        startButtonColor = globalSliderColor;
        startButtonFontColor = AppColors.PRIMARY_COLOR_GREEN;
        break;
      case ThemeEnum.community:
          DynamicTheme.of(context)
              .setThemeData(new ThemeData(primaryColor: Colors.indigo));
        globalPrimaryColor = Color(0xff543864);
        globalBackgroundColor =  Color(0xff202040);
        globalTextFontColor = Colors.white70;
        globalSliderColor = Color(0xfffee4a6);//Color(0xffffbd05);//Color(0xffff6363);
        globalButtonFontColor = AppColors.PRIMARY_COLOR_WHITE;
        globalButtonColor = globalPrimaryColor;
        startButtonColor = Color(0xffffbd69);
        startButtonFontColor = globalButtonFontColor;
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
              theme: globalTheme,
            ),
          );
        });
  }

  refreshSettings(double timer, double dices, String templateName, String theme) {
    setState(() {
      SetSettings(timer.toInt(), dices.toInt(), templateName, theme);
    });
  }

  _updateDbCntr() async {
    DatabaseSettings helper = DatabaseSettings.instance;
    dbCntr = await helper.getRowsCnt() + 1;
    return dbCntr;
  }
}
