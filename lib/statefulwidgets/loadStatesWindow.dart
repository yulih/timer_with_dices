import 'package:flutter/material.dart';
import 'package:timer_with_dices/Utils/time.dart';
import 'package:timer_with_dices/database/dbSettings.dart';
import 'package:timer_with_dices/models/settingsModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LoadStates extends StatefulWidget {
  Function notifyParent;
  LoadStates({Key key, this.notifyParent}) : super(key: key);

  @override
  _LoadStates createState() => _LoadStates();
}

class _LoadStates extends State<LoadStates> {
  var items = [];
  Settings setting;
  DatabaseSettings helper = DatabaseSettings.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          //https://github.com/letsar/flutter_slidable
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              Settings project = snapshot.data[index];
              final item = project.configname;
              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(item),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() async {
                    _deleteByName(item);
                  });

                  // Then show a snackbar.
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text('$item'),
                  onTap: () {
                    _loadState(item);
                    // Then show a snackbar.
                    Navigator.of(context).pop(true);
                  },
                ),
              );
            },
          );
        },
        future: _readStates(),
      ),
    );
  }

  _loadState(String id) async {
    setting = await helper.readSingle(id);
    widget.notifyParent(setting.timer.toDouble(), setting.dices.toDouble(), setting.configname);
    print(setting.configname);
  }

  _readStates() async {
    var q = await helper.getRowsCnt();
    if (q == 0) {
      Settings setting = Settings(
          timer: 90, dices: 2, theme: 'bright', configname: 'Catan', currdatetime: TimeUtil.currentTimeInSeconds());
      items = await helper.InsertRead(setting);
      return items;
    }
    items = await helper.readAll();
    return items;
  }

  _deleteByName(String name) async {
    int count = await helper.DeleteByConfigname(name);
    print('deleted $count row(s)');
  }
}
