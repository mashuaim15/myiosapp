import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Weather extends StatelessWidget {
  final Map<String, dynamic> data;
  Weather(this.data);



  Widget build(BuildContext context) {
    double temp = data['current']['temp_c'];
    var datetime = data['location']['localtime'];
    var condition = data ['current']['condition']['text'];
    var name = data ['location']['name'];
    var icon = data ['current']['condition']['icon'];
    var width = MediaQuery.of(context).size.width-150;
    var iconI =icon.toString();
    var iconII = iconI.replaceAll('//', "http://");
    var iconIII = iconI.replaceAll('//cdn.apixu.com/weather/64x64/', '');

    //var iconIIII = iconIII.replaceAll('/116.png', '');

    var iFinal = iconIII.substring(0,iconIII.length - 8);

    var day = 'http://www4.comp.polyu.edu.hk/~icba/img/hong-kong-day.JPG';
    var night = 'http://www.vans.com.hk/wp-content/uploads/2015/10/House-of-vans-Hong-Kong-day-1-highlight_1.jpg';

    if (iFinal == 'day') {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            title: Image.network(iconII, width: width),

          ),

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'http://b387.photo.store.qq.com/psb?/V10WptRi0y0dmR/lmfYL0bYZQHGrhGN4f9pLkfDL0HfdH8twJWqS.2rYrw!/b/dIMBAAAAAAAA&bo=AAXAAwAFwAMRBzA!&rf=viewer_4'),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Divider(height: 70.0, color: Colors.transparent,),
                Text('$name', style: TextStyle(fontWeight:FontWeight.bold,fontStyle:FontStyle.italic,fontSize: 40.0, color: Colors.black,),),
                Divider(height: 40.0, color: Colors.transparent,),
                Text('$condition', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 35.0, color: Colors.black87)),
                Text('${temp.toStringAsFixed(
                    1)}°C', style: TextStyle(fontSize: 35.0,color: Colors.black)),
                Divider(height: 45.0, color: Colors.transparent,),
                Text('Local time:\n$datetime', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30.0, color: Colors.black87)),
                Divider(height: 20.0, color: Colors.transparent,),



              ],
            ),
          )
      );
    }

    else{

      return Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            title: Image.network(iconII, width: width),

          ),

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'http://m.qpic.cn/psb?/V10WptRi0y0dmR/4vwTilC8DpMTJLUhnT7u8l7QH4gr72Yk7TW4RcpdekM!/b/dCUAAAAAAAAA&bo=5AirBuQIqwYRFyA!&rf=viewer_4'),
                fit: BoxFit.cover,
              ),
            ),
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Divider(height: 70.0, color: Colors.transparent,),
                Text('$name', style: TextStyle(fontWeight:FontWeight.bold,fontStyle:FontStyle.italic,fontSize: 40.0, color: Colors.white,),),
                Divider(height: 40.0, color: Colors.transparent,),
                Text('$condition', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 35.0, color: Colors.white)),
                Text('${temp.toStringAsFixed(
                    1)}°C', style: TextStyle(fontSize: 35.0,color: Colors.white)),
                Divider(height: 70.0, color: Colors.transparent,),
                Text('Local time:\n$datetime', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 35.0, color: Colors.white)),
                Divider(height: 20.0, color: Colors.transparent,),


              ],
            ),
          )
      );
    }

  }
}

class Wh extends StatefulWidget {
  WhState createState() => new WhState();
}

class WhState extends State<Wh> {
  Future<http.Response> _response;

  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _response = http.get(
          'http://api.apixu.com/v1/current.json?key=86a3132248aa48068c1123544181211&q=vancouver'
      );}
    );
  }


  Widget build(BuildContext context) {




    return new Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed : _refresh,
      ),

      body: new Center(

          child: new FutureBuilder(
              future: _response,
              builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
                if (!response.hasData)
                  return new Text('3...2...1...');
                else if (response.data.statusCode != 200) {
                  return new Text('Could not connect to weather service.');
                } else {
                  Map<String, dynamic> json = jsonDecode(response.data.body);

                  return new Weather(json);
                }
              }
          )
      ),
    );
  }
}