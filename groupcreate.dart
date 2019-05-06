import 'global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class GroupCreatePage extends StatefulWidget {
  @override createState() => GroupCreateState();
}

class GroupCreateState extends State {

  var images = [];

  var selectedCourse = roles.keys.first;
  var title = '';
  var content = '';
  var leader ='';
  var t = 'Group icon';

  void attach(source) {
    ImagePicker.pickImage(source: source).then((file){
      if (file != null)
        setState(() => images.add(file));
    });
  }



  @override
  Widget build(BuildContext context) {

    var items = <DropdownMenuItem>[];
    for (var k in roles.keys) {
      var v = roles[k];
      if (['teacher', 'administrator','student'].contains(v))
        items.add(DropdownMenuItem(value: k, child: Text(k)));
    }
    var ddButton = DropdownButton(
      value: selectedCourse,
      items: items,
      onChanged: (course) => setState(() => selectedCourse = course),
    );

    var widgets = <Widget>[
      Text('Choose Class:'),
      ddButton,
      TextField(
        decoration: InputDecoration(hintText: 'Group Name',),
        onChanged: (text) => setState(() => title = text),
      ),
      Divider(color: Colors.transparent,),
      TextField(
        decoration: InputDecoration(hintText: 'Group Leader',),
        onChanged: (text) => setState(() => leader = text),
      ),
      Divider(color: Colors.transparent,),
      TextField(
        decoration: InputDecoration(hintText: 'Group Members',),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (text) => setState(() => content = text),
      ),
      Divider(height:32.0,color: Colors.transparent,),
      Text(t)
    ];


    var width = MediaQuery.of(context).size.width - 120;

    for (var f in images) {
      widgets.add(Divider(color: Colors.transparent,));
      widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.file(f, width: width),
              IconButton(icon: Icon(Icons.cancel), iconSize: 32.0,
                onPressed: () => setState(() => images.remove(f)),
              )
            ],
          )
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Group Formation'),
        actions: <Widget>[


          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () => attach(ImageSource.gallery),
          ),


          IconButton(icon: Icon(Icons.send), onPressed: () => post(),),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[Column(children: widgets)],
      ),
    );


  }



  void post() {
    var ref = dbRef.child('courses/$selectedCourse/groups').push();
    ref.set({
      'key' : ref.key,
      'course' : selectedCourse,
      'Group Name' : title,
      'Group Leader': leader,
      'Group Member' : content,
      'createdAt' : DateTime.now().millisecondsSinceEpoch,
      'createdBy' : userID,
    });

    for (var i=0; i < images.length; i++) {
      var fRef = storageRef.child(ref.key + '/$i');
      var task = fRef.putFile(images[i]);
      task.future.then((snapshot) =>
          ref.child('images/$i').set(snapshot.downloadUrl.toString())
      );
    }

    Navigator.pop(context);
  }
}