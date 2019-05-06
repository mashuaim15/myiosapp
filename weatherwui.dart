import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Weather extends StatefulWidget {
  final Map<String, dynamic> data;
  Weather(this.data);
  Widget build(BuildContext context) {
    double temp = data['current']['temp_c'];
    //DateTime wea = data['location']['localtime'];
    var datetime = data['location']['localtime'];
    var condition = data ['current']['condition']['text'];
    var name = data ['location']['name'];


    //     return new

    //     Text('$name\n\n$condition\n ${temp.toStringAsFixed(1)} °C\n\nlocal time:\n$datetime',
     //    style: Theme.of(context).textTheme.display2,);

  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  }
}

class W extends StatefulWidget {
  WState createState() => new WState();
}

class WState extends State<W> {
  Future<http.Response> _response;

  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _response = http.get(
          'http://api.apixu.com/v1/current.json?key=86a3132248aa48068c1123544181211&q=hongkong'
      );
    });
  }


  Widget build(BuildContext context) {


    var childWidgets = <Widget>[
      FutureBuilder(
          future: _response,
          builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
            if (!response.hasData)
              return new Text('3...2...1...');
            else if (response.data.statusCode != 200) {
              return new Text('Could not connect to weather service.');
            } else {
              Map<String, dynamic> json = jsonDecode(response.data.body);
              //if (json['cod'] == 200)
              return new Weather(json);
              // else
              //return new Text('Weather service error.');
            }
          }
      )


    ];


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Weather"),
      ),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: _refresh,
      ),
      body: new Center(


      ),
    );
  }
}