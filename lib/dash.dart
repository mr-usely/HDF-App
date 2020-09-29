import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Widgets/List_accomplish.dart';
import 'Widgets/Report.dart';

class HDFhome extends StatefulWidget {
  final int idname;

  HDFhome({Key key, @required this.idname}) : super(key: key);
  @override
  _HDFhomeState createState() => _HDFhomeState(idname);
}

class _HDFhomeState extends State<HDFhome> {
  int idname;
  _HDFhomeState(this.idname);

  int tabs = 1;
  int id = 7;

  changeTab() {
    if (tabs == 1) {
      return ListAccomplish(idname: idname);
    } else if (tabs == 0) {
      return Reports(idname: idname);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tab = Column(
      children: [
        Card(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
            elevation: 10,
            child: FittedBox(
              fit: BoxFit.cover,
              child: ButtonBar(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 5.0, top: 10.0, bottom: 10.0),
                      child: new FlatButton(
                          onPressed: () {
                            setState(() {
                              tabs = 1;
                            });
                          },
                          child: new Row(children: <Widget>[
                            new Image.asset('asset/img/health.png',
                                height: 40.0, width: 40.0),
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: new Text('List to\nAccomplish',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ]))),
                  Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    height: 50,
                    child: VerticalDivider(
                      color: Colors.black45,
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 9.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: new FlatButton(
                          onPressed: () {
                            setState(() {
                              tabs = 0;
                            });
                          },
                          child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Image.asset('asset/img/report.png',
                                    height: 40.0, width: 40.0),
                                Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: new Text('Reports',
                                      style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ])))
                ],
              ),
            )),
      ],
    );
    var col = Column(
      children: [
        Card(
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 40),
          elevation: 20,
          child: changeTab(),
        )
      ],
    );
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Health Declaration',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
              child: ListView(children: <Widget>[
            tab,
            col,
          ])),
        ),
        onWillPop: () => showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Do you really want to exit?'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(c, false),
                    ),
                  ],
                )));
  }
}