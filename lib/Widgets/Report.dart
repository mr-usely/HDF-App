import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  final int idname;
  Reports({Key key, @required this.idname}) : super(key: key);
  @override
  _ReportsState createState() => _ReportsState(idname);
}

class _ReportsState extends State<Reports> {
  int idname;
  _ReportsState(this.idname);
  int tabs = 0;

  fontChange() {
    if (tabs == 0) {
      return FontWeight.w800;
    } else {
      return FontWeight.w700;
    }
  }

  fontChange1() {
    if (tabs == 1) {
      return FontWeight.w800;
    } else {
      return FontWeight.w700;
    }
  }

  fontChange2() {
    if (tabs == 2) {
      return FontWeight.w800;
    } else {
      return FontWeight.w700;
    }
  }

  colorChange() {
    if (tabs == 0) {
      return Color.fromRGBO(245, 244, 244, 1);
    } else {
      return Colors.white;
    }
  }

  colorChange1() {
    if (tabs == 1) {
      return Color.fromRGBO(245, 244, 244, 1);
    } else {
      return Colors.white;
    }
  }

  colorChange2() {
    if (tabs == 2) {
      return Color.fromRGBO(245, 244, 244, 1);
    } else {
      return Colors.white;
    }
  }

  borderChange() {
    if (tabs == 0) {
      return Color.fromRGBO(16, 204, 169, 1);
    } else {
      return Colors.white;
    }
  }

  borderChange1() {
    if (tabs == 1) {
      return Color.fromRGBO(16, 204, 169, 1);
    } else {
      return Colors.white;
    }
  }

  borderChange2() {
    if (tabs == 2) {
      return Color.fromRGBO(16, 204, 169, 1);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var summary = Container(
        color: Color.fromRGBO(245, 244, 244, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 2,
                width: 395,
                child: Container(
                  margin: const EdgeInsets.only(left: 100),
                  color: Color.fromRGBO(16, 204, 169, 1),
                )),
            // Table header
            Container(
              padding:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 30,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text('PM',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Total Personel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 70,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Not Yet Accomplish',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Accomplished of the Day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 30,
                      margin: const EdgeInsets.only(left: 5),
                      child: Text('%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                  ]),
            ),
            SizedBox(
                width: 360,
                height: 1,
                child: Container(
                  color: Colors.black12,
                )),
            // Tabe Data
            Container(
              padding:
                  const EdgeInsets.only(left: 5, top: 10, right: 0, bottom: 20),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    //PM
                    // Container(
                    //   width: 35,
                    //   padding: const EdgeInsets.only(right: 5),
                    //   child: Text('JPC',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Total Personel
                    // Container(
                    //   width: 75,
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('15',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Not Yet Accomplish
                    // Container(
                    //   width: 85,
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('5',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Accomplished of the Day
                    // Container(
                    //   width: 90,
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('10',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Percentage
                    // Container(
                    //   width: 50,
                    //   padding: const EdgeInsets.only(
                    //     left: 5,
                    //   ),
                    //   child: Text('66.6' + '%',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                  ]),
            )
          ],
        ));
    var highTemperature = Container(
        color: Color.fromRGBO(245, 244, 244, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 145),
                  width: 105,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                ),
                Container(
                  width: 121,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                )
              ],
            )),
            // Table header
            Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 20, right: 10, bottom: 10),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 50,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Employee ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Position',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 60,
                      margin: const EdgeInsets.only(left: 5, right: 0),
                      child: Text('Temp.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ]),
            ),
            SizedBox(
                width: 360,
                height: 1,
                child: Container(
                  color: Colors.black12,
                )),
            // Tabe Data
            Container(
              margin: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 20),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    // Name
                    // Container(
                    //   width: 55,
                    //   margin: const EdgeInsets.only(left: 5),
                    //   child: Text('Kim Adorna',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Employee ID
                    // Container(
                    //   width: 105,
                    //   margin: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('1511359',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Position
                    // Container(
                    //   width: 85,
                    //   margin: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('JP',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Temperatire
                    // Container(
                    //   width: 60,
                    //   margin: const EdgeInsets.only(left: 10),
                    //   child: Text('36.0',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                  ]),
            )
          ],
        ));
    var symptoms = Container(
        color: Color.fromRGBO(245, 244, 244, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 98),
                  width: 248,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                ),
                Container(
                  width: 26,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                )
              ],
            )),
            // Table header
            Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 20, right: 10, bottom: 10),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 50,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Employee ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Position',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 60,
                      margin: const EdgeInsets.only(left: 5),
                      child: Text('Sympt.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ]),
            ),
            SizedBox(
                width: 360,
                height: 1,
                child: Container(
                  color: Colors.black12,
                )),
            // Tabe Data
            Container(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 20),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    // Container(
                    //   width: 55,
                    //   margin: const EdgeInsets.only(left: 5),
                    //   child: Text('Kim Adorna',
                    //       textAlign: TextAlign.left,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Employee ID
                    // Container(
                    //   width: 105,
                    //   margin: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('1511359',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // Position
                    // Container(
                    //   width: 85,
                    //   margin: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Text('JP',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // ),
                    // symptoms
                    // Container(
                    //   width: 60,
                    //   margin: const EdgeInsets.only(
                    //     left: 5,
                    //   ),
                    //   child: Text('Fever',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontWeight: FontWeight.w600)),
                    // )
                  ]),
            )
          ],
        ));

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(children: <Widget>[
            Center(
              child: Text('Reports',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: 'Open Sans')),
            )
          ]),
        ),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: borderChange(),
                          spreadRadius: 1,
                          offset: Offset(2, -1.2),
                        )
                      ],
                    ),
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            tabs = 0;
                          });
                        },
                        color: colorChange(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0)),
                        ),
                        child: Text(
                          'Summary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: fontChange(),
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              color: Colors.black),
                        ))),
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: borderChange1(),
                          spreadRadius: 2,
                          offset: Offset(0, -0.5),
                        )
                      ],
                    ),
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            tabs = 1;
                          });
                        },
                        color: colorChange1(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                        ),
                        child: Text(
                          'High Temperature',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: fontChange1(),
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              color: Colors.black),
                        ))),
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: borderChange2(),
                          spreadRadius: 2,
                          offset: Offset(0, -0.5),
                        )
                      ],
                    ),
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            tabs = 2;
                          });
                        },
                        color: colorChange2(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                        ),
                        child: Text(
                          'Symptoms',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: fontChange2(),
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              color: Colors.black),
                        ))),
              ],
            )),
        if (tabs == 0)
          summary
        else if (tabs == 1)
          highTemperature
        else if (tabs == 2)
          symptoms
      ],
    );
  }
}
