import 'package:timer_with_dices/database/dbSettings.dart';
import 'package:timer_with_dices/models/ThemeEnum.dart';

class Settings {
  int timer;
  int dices;
  String theme;
  String templateName;
  int currdatetime;

  Settings({this.templateName, this.timer, this.theme, this.dices, this.currdatetime});

  // Convert a Setting into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'timer': timer,
      'theme': theme,
      'dices': dices,
      'configname': templateName,
      'currDateTime': currdatetime,
    };
  }

  // convenience constructor to create a Workout object
  Settings.fromMap(Map<String, dynamic> map) {
    this.timer = map[dbTimer];
    this.dices = map[dbDices];
    this.theme = map[dbTheme];
    this.templateName = map[dbConfigNameId];
    this.currdatetime = map[dbCurrDateTime];
  }
}
