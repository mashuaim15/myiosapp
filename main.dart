import 'package:flutter/material.dart';
import 'home.dart';
import 'Notification_list.dart';
import 'Notification_view.dart';
import 'notification_create.dart';
import 'global.dart';
import 'grouplist.dart';
import 'groupcreate.dart';
import 'note.dart';
import 'todays weather.dart';
import 'groupview.dart';
import 'homeweather.dart';

void main() {


  firebaseInit();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/notificationList':
            (BuildContext context) => NotificationListPage(),
        '/notificationView':
            (BuildContext context) => NotificationViewPage(),
        '/notificationCreate':
            (BuildContext context) => NotificationCreationPage(),
        '/grouplist':
            (BuildContext context) => GroupListPage(),
        '/groupform':
            (BuildContext context) => GroupCreatePage(),
        '/note':
            (BuildContext context) => TodoList(),
        '/home':
            (BuildContext context) => HomePage(),
        '/weather':
            (BuildContext context) => W(),
        '/GroupView':
            (BuildContext context) => GroupView(),
        '/hw':
            (BuildContext context) => Wh(),

      },
    );
  }
}