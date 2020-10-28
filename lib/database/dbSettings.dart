import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timer_with_dices/models/settingsModel.dart';
import 'package:path_provider/path_provider.dart'; // needed for getApplicationDocumentsDirectory()

// database table and column names
final String dbTableName = 'Settings';
final String dbTheme = 'theme';
final String dbDices = 'dices';
final String dbTimer = 'timer';
final String dbConfigNameId = 'configname';
final String dbCurrDateTime = 'currDateTime';

class DatabaseSettings {
// This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "settings_database.db";
// Increment this version when you need to change the schema.
  static final _databaseVersion = 3;

// Make this a singleton class.
  DatabaseSettings._privateConstructor();
  static final DatabaseSettings instance = DatabaseSettings._privateConstructor();

// Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

// open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database, can also add an onUpdate callback parameter.
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

// SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $dbTableName (
            $dbDices INTEGER NOT NULL,
            $dbTimer INTEGER NOT NULL,
            $dbTheme TEXT NOT NULL,
            $dbConfigNameId TEXT PRIMARY KEY,
            $dbCurrDateTime INTEGER DEFAULT (cast(strftime('%s','now') as int))
          )
          ''');

/*    var template1 = Settings(configname: 'Template 1', dices: 2, timer: 90, theme: 'bright');
    await insert(template1);*/
  }

  // UPGRADE DATABASE TABLES
  // https://efthymis.com/migrating-a-mobile-database-in-flutter-sqlite/
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      db.execute("ALTER TABLE $dbTableName ADD COLUMN $dbConfigNameId TEXT NOT NULL;");
    }
  }

// Database helper methods:
  Future<String> printDbMsg(Database db, String tableName, String message) async {
    List<Map> maps = await db.query(tableName);
    var length = maps.length;
    return '$message $length';
  }

  Future<int> insert(Settings setting) async {
    final Database db = await database;
    print(await printDbMsg(db, dbTableName, "Before insert: "));
    int id = await db.insert(
      'settings',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(await printDbMsg(db, dbTableName, "After insert: "));
    return id;
  }

  Future<List<Settings>> InsertRead(Settings setting) async {
    final Database db = await database;
    int id = await db.insert(
      'settings',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Map> maps = await db.query(dbTableName);
    if (maps.length > 0) {
      List<Settings> settings = [];
      maps.forEach((map) => settings.add(Settings.fromMap(map)));
      return settings;
    }
    return null;
  }

  Future<List<Settings>> readAll() async {
    Database db = await database;
    //print(await db.query(dbTableName));
    List<Map> maps = await db.query(dbTableName);
    if (maps.length > 0) {
      List<Settings> settings = [];
      maps.forEach((map) => settings.add(Settings.fromMap(map)));
      return settings;
    }
    return null;
  }

  Future<Settings> readSingle(String configNameId) async {
    Database db = await database;
    List<Map> maps = await db.query(dbTableName, where: '$dbConfigNameId = ?', whereArgs: [configNameId]);
    if (maps.length > 0) {
      return Settings.fromMap(maps.first);
    }
    return null;
  }

  Future<int> DeleteByConfigname(String configName) async {
    Database db = await database;
    return await db.delete(dbTableName, where: '$dbConfigNameId = ?', whereArgs: [configName]);
  }

  //not used anymore. replaced by Lastused
  Future<Settings> getLastUsedTemplateFromLatestSaved() async {
    Database db = await database;
    // raw query
    List<Map> maps = await db.rawQuery('SELECT '
        '${dbConfigNameId}'
        ' FROM '
        '${dbTableName}'
        ' WHERE '
        '${dbCurrDateTime} = (SELECT MAX(${dbCurrDateTime}) FROM ${dbTableName})');
    if (maps.length > 0) {
      return Settings.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getRowsCnt() async {
    Database db = await database;
    List<Map> maps = await db.query(dbTableName);
    return maps.length;
  }

/*
  Future<Workout> queryWorkout(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableWorkouts,
        columns: [cId, cWorkout, cExercise, cSet, cWeek, cFirst, cSecond], where: '$cId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Workout.fromMap(maps.first);
    }
    return null;
  }

    Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(dbTableName, where: '$dbID = ?', whereArgs: [id]);
  }

  Future<int> update(Workout workout) async {
    Database db = await database;
    return await db.update(tableWorkouts, workout.toMap(), where: '$cId = ?', whereArgs: [workout.id]);
  }*/
}
