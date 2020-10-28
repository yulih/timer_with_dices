import 'package:flutter/material.dart';
import 'package:timer_with_dices/database/dbSettings.dart';
import 'package:timer_with_dices/models/settingsModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LoadStates extends StatefulWidget {
  LoadStates({Key key}) : super(key: key);

  @override
  _LoadStates createState() => _LoadStates();
}

class _LoadStates extends State<LoadStates> {
  var items = [];

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
                    _delete(index);
                  });

                  // Then show a snackbar.
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: ListTile(title: Text('$item')),
              );
            },
          );
        },
        future: _readStates(),
      ),
    );
  }

  _readStates() async {
    // query one word
    DatabaseSettings helper = DatabaseSettings.instance;
    items = await helper.readAll();
    return items;
  }

  _delete(int id) async {
    DatabaseSettings helper = DatabaseSettings.instance;
    int count = await helper.delete(id);
    print('deleted $count row(s)');
  }
}


new Slidable(
delegate: new SlidableScrollDelegate(),
actionExtentRatio: 0.25,
child: new Container(
color: Colors.white,
child: new ListTile(
leading: new CircleAvatar(
backgroundColor: Colors.indigoAccent,
child: new Text('$3'),
foregroundColor: Colors.white,
),
title: new Text('Tile n°$3'),
subtitle: new Text('SlidableDrawerDelegate'),
),
),
actions: <Widget>[
new IconSlideAction(
caption: 'Archive',
color: Colors.blue,
icon: Icons.archive,
onTap: () => _showSnackBar('Archive'),
),
new IconSlideAction(
caption: 'Share',
color: Colors.indigo,
icon: Icons.share,
onTap: () => _showSnackBar('Share'),
),
],
