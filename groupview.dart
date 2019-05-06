import 'global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';


class GroupView extends StatefulWidget {
  @override createState() => GroupViewState();
}
class GroupViewState extends State {
  var images = [];

  @override
  void initState() {
    super.initState();
    if (groupselection['images'] != null)
      for (var url in groupselection['images']) {
        http.get(url).then((response) {
          images.add(response.bodyBytes);
          if (mounted)
            setState(() {});
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    var data = groupselection;
    var title = data['Group Name'];
    var course = data['course'];
    var content = data['Group Member'];
    var createdBy = data['createdBy'];
    var datetime = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
    var createdAt = DateFormat('EEE, MMMM d, y H:m:s', 'en_US').format(
        datetime);
    var gm = 'Group Members:';
    var leader = data['Group Leader'];
    var ld = 'Group Leader:';
    var icon = 'Group Icon:';


    var childWidgets = <Widget>[
      Text(title, style: TextStyle(fontSize: 30.0, color: Colors.deepOrange),),
      Divider(height: 30.0, color: Colors.transparent,),
      Text(ld, style: TextStyle(fontSize: 30.0, color: Colors.blue)),
      Text(leader, style: TextStyle(fontSize: 30.0)),
      Divider(height: 20.0, color: Colors.transparent,),
      Text(gm, style: TextStyle(fontSize: 30.0, color: Colors.lightBlue)),
      Divider(height: 20.0, color: Colors.transparent,),
      Text(content, style: TextStyle(fontSize: 30.0),),
      Divider(height: 30.0, color: Colors.transparent,),
      Text(icon)
    ];
    var width = MediaQuery
        .of(context)
        .size
        .width - 120;
    for (var i in images) {
      childWidgets.add(Divider(color: Colors.transparent));
      childWidgets.add(Image.memory(i, width: width));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(course),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: childWidgets,
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Text('$createdAt by $createdBy'),
        (['teacher', 'administrator'].contains(roles[course]))?
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => delete(),
        ):null,
      ],
    );
  }
  void delete() {
    var key = notificationSelection['key'];
    var course = notificationSelection['course'];
    dbRef.child('courses/$course/notifications/$key').remove();
    for (var i = 0; i < images.length; i++)
      storageRef.child('$key/$i').delete();
    Navigator.pop(context);
  }
}