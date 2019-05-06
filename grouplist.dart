import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';


class GroupListPage extends StatefulWidget {
  @override createState() => GroupListState();
}
class GroupListState extends State {

  var canCreate = false;
  var nMap = {};

  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getGroupList());
  }


  void getGroupList() {
    Set roleSet, courseSet;
    if (roles != null) {
      roleSet = roles.values.toSet();
      courseSet = roles.keys.toSet();
    } else {
      roleSet = Set();
      courseSet = Set();
    }
    courseSet.add('ALL');
    canCreate = roleSet.contains('teacher''student')
        || roleSet.contains('administrator');
    for (var a in courseSet) {
      var aRef = dbRef.child('courses/$a/groups');
      aRef.onValue.listen((event) {
        if (event.snapshot.value == null) nMap.remove(a);
        else nMap[a] = (event.snapshot.value as Map).values.toList();
        if (mounted) setState(() {});
      });
    }
  }


  @override Widget build(BuildContext context) {
    var widgetList = <Widget>[];

    var data = List();
    for (List c in nMap.values)
      data.addAll(c);
    data.sort((a, b) => b['createdAt'] - a['createdAt']);
// for (var i = 1; i <= 20; i++) {
// var item = 'Notification $i';
    for (var i=0; i<data.length; i++){
      var item = data[i];
      var title = item['Group Name'];
      var course = item['course'];
      var datetime = DateTime.fromMillisecondsSinceEpoch(item['createdAt']);
      var createdAt = DateFormat('EEE, MMMM d, y H:m:s',
          'en_US').format(datetime);
      var leader = item['Group Leader'];
      var gn = 'Group Leader:';


      widgetList.add(
          ListTile(
              leading: Icon(Icons.group),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(gn+leader,
                    style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),),
                ],
              ),
              trailing: Text(course.replaceAll(' ', '\n'),
                textAlign: TextAlign.right,),


              onTap: () {
                groupselection = item;
                Navigator.pushNamed(context, '/GroupView');
              }


          )
      );
    }
    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.group_add),
        onPressed: ()=>Navigator.pushNamed(context, '/groupform'),
      ) : null,

      appBar: AppBar(title: Text('Groups'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}