import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdf_app/dash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hdf_app/Class/Servers.dart';

MediaQueryData queryData;

class HDFPreview extends StatefulWidget {
  final int superiorID;
  final int id;
  final int idEmployee;
  final String temperature;
  final String name;
  final String position;
  final String encoder;

  HDFPreview(
      {Key key,
      @required this.superiorID,
      this.id,
      this.idEmployee,
      this.name,
      this.position,
      this.temperature,
      this.encoder})
      : super(key: key);
  @override
  _HDFPreviewState createState() => _HDFPreviewState(
      superiorID, id, idEmployee, name, position, temperature, encoder);
}

class AnswerList {
  String first; // First Question Answer
  String second; // Second Question Answer
  String third; // Third Question Answer
  String fourth; // Fourth Question Answer

  AnswerList({this.first, this.second, this.third, this.fourth});
}

class _HDFPreviewState extends State<HDFPreview> {
  int superiorID;
  int id;
  int idEmployee;
  String temperature;
  String name;
  String position;
  String encoder;
  _HDFPreviewState(this.superiorID, this.id, this.idEmployee, this.name,
      this.position, this.temperature, this.encoder);

  List<AnswerList> answerList = [];

  Future<List> getJsonData() async {
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?Get_Form_Data=" + '$idEmployee';
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  fetchdata() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData() != null) {
          List _jsonValue = await getJsonData();

          if (_jsonValue != null) {
            setState(() {
              for (var i = 0; i < _jsonValue.length; i++) {
                answerList.add(AnswerList(
                    first: _jsonValue[i]['first'],
                    second: _jsonValue[i]['second'],
                    third: _jsonValue[i]['third'],
                    fourth: _jsonValue[i]['fourth']));
              }

              parseString1(answerList.length.toString());
              // print(answerList[0].first +
              //     ', ' +
              //     answerList[0].second +
              //     ', ' +
              //     answerList[0].third +
              //     ', ' +
              //     answerList[0].fourth);
            });
          } else {
            answerList
                .add(AnswerList(first: '', second: '', third: '', fourth: ''));
          }
        } else {
          answerList
              .add(AnswerList(first: '', second: '', third: '', fourth: ''));
        }
      }
    } on SocketException catch (_) {
      showAlertDialog1(context);
    }
  }

  parseString1(String data) {
    if (data.length != 0)
      return data;
    else
      return Text('');
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
    print(superiorID);
  }

  backButton() {
    //if (idEmployee != null) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: Color.fromARGB(220, 16, 204, 169)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HDFhome(
                      idname: superiorID,
                      encoder: encoder,
                    )),
          );
        });
    //}
    //else {
    // return IconButton(
    //     icon: Icon(Icons.arrow_back_ios,
    //         color: Color.fromARGB(220, 16, 204, 169)),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     });
    //}
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
                              margin: const EdgeInsets.only(bottom: 5),
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  child: Text('1. Symptoms experienced in 14 days.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5)),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 40, bottom: 20, right: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                          child: Column(
                        children: List.generate(
                          answerList.length,
                          (index) => Container(
                            child: Text(
                              'Answer: ' + answerList[index].first,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Open Sans'),
                            ),
                          ),
                        ),
                      )),
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
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 20.0),
                child: Row(children: <Widget>[
                  Container(
                      child: Column(
                    children: List.generate(
                      answerList.length,
                      (index) => Text(
                        'Answer: ' + answerList[index].second,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans'),
                      ),
                    ),
                  )),
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
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 20.0),
                child: Row(children: <Widget>[
                  Container(
                      child: Column(
                    children: List.generate(
                      answerList.length,
                      (index) => Text(
                        'Answer: ' + answerList[index].third,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans'),
                      ),
                    ),
                  )),
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
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 20.0),
                child: Row(children: <Widget>[
                  Container(
                      child: Column(
                    children: List.generate(
                      answerList.length,
                      (index) => Text(
                        'Answer: ' + answerList[index].fourth,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans'),
                      ),
                    ),
                  )),
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
            brightness: Brightness.light,
            title: Text(
              'Health Declaration Form',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
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

showAlertDialog1(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("No Internet Connection"),
    content: Text("Please Connect to the Internet!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
