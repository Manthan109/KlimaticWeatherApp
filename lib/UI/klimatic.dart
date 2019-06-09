import 'dart:async';
import 'dart:convert';
import '../Util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class klimatic extends StatefulWidget {
  @override
  _klimaticState createState() => _klimaticState();
}

class _klimaticState extends State<klimatic> {
  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
      return ChangeCity();
    }));
    if (results != null && results.containsKey("enter")) {
      _cityEntered = results["enter"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kimatic",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
            color: Colors.red,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(
            "images/nightsky.jpg",
            fit: BoxFit.fill,
            width: 500.0,
          )),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(0.0, 15.1, 20.0, 2.0),
            child: Text(
              "${_cityEntered == null ? util.defaultCity : _cityEntered}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(35.0, 300.0, 120.0, 40.0),
              child: updateTempWidget(_cityEntered))
        ],
      ),
    );
  }

  Future<Map> getWeather(String appID, String city) async {

    String apiURL =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appID}&units=metric";
    http.Response _response = await http.get(apiURL);
    return json.decode(_response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.appID, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(content["main"]["temp"].toString() + "C",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold)),
                    subtitle: ListTile(
                      title: Text(
                        "Humidity : ${content["main"]["humidity"].toString()}\n" +
                            "Min : ${content["main"]["temp_min"].toString()}C\n" +
                            "Max : ${content["main"]["temp_max"].toString()}C",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Klimatic",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(
            "images/nasa.jpg",
            height: 600,
            width: 500,
            fit: BoxFit.fill,
          )),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City",
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {"enter": _cityFieldController.text});
                  },
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  child: Text("Get Weather"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
