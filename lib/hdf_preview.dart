import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:HDF_App/dash.dart';

MediaQueryData queryData;

class HDFPreview extends StatefulWidget {
  final int id;
  final int idEmployee;
  final String temperature;
  final String name;
  final String position;

  HDFPreview(
      {Key key,
      @required this.id,
      this.idEmployee,
      this.name,
      this.position,
      this.temperature})
      : super(key: key);
  @override
  _HDFPreviewState createState() =>
      _HDFPreviewState(id, idEmployee, name, position, temperature);
}

class _HDFPreviewState extends State<HDFPreview> {
  int id;
  int idEmployee;
  String temperature;
  String name;
  String position;
  _HDFPreviewState(
      this.id, this.idEmployee, this.name, this.position, this.temperature);
  @override
  void initState() {
    super.initState();
  }

  backButton() {
    if (idEmployee != null) {
      return IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(220, 16, 204, 169)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HDFhome(idname: id)),
            );
          });
    } else {
      return IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(220, 16, 204, 169)),
          onPressed: () {
            Navigator.pop(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var firstcard = Column(
      children: [
        Card(
            shadowColor: Colors.black,
            elevation: 15,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 170,
                              child: Text(
                                'Employee ID: ' + '$idEmployee',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 170,
                              margin: const EdgeInsets.only(bottom: 45),
                              child: Text(
                                'Name: ' + name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              child: Text(
                                'Position: ' + position,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                            Container(
                              width: 130,
                              child: Text(
                                'Temperature: ' + temperature,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ],
    );
    var secondcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                  '1. In the past 14 days, which of the following' +
                      ' symptom(s) have you experienced, please check (✓) the' +
                      " relevant box(es). If it's not your first time filling up this" +
                      " form, kindly just indicate what you're experiencing right now.",
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 130,
                    child: Text(
                      'Answer: ' + position,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: 'Open Sans'),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ],
    );
    var thirdcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '2. Have you been in contact with a confirmed COVID-19 ' +
                        'patient in the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    width: 130,
                    child: Text(
                      'Answer: ' + position,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: 'Open Sans'),
                    ),
                  ),
                ]))
          ]),
        )
      ],
    );
    var fourthcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '3. Have you had any contact with anyone with the above ' +
                        'symptoms in the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    width: 130,
                    child: Text(
                      'Answer: ' + position,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: 'Open Sans'),
                    ),
                  ),
                ]))
          ]),
        )
      ],
    );
    var fifthcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '4. Have you been to identified high risk areas of COVID-19 in' +
                        ' the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    width: 130,
                    child: Text(
                      'Answer: ' + position,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: 'Open Sans'),
                    ),
                  ),
                ]))
          ]),
        )
      ],
    );

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: backButton(),
            title: Text(
              'Health Declaration Form',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
          ),
          body: ListView(children: <Widget>[
            firstcard,
            secondcard,
            thirdcard,
            fourthcard,
            fifthcard
          ]),
        ),
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
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
              ),
            ));
  }
}
