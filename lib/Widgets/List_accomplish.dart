import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:HDF_App/hdf_form.dart';
import 'package:http/http.dart' as http;

class ListAccomplish extends StatefulWidget {
  final int idname;

  ListAccomplish({Key key, @required this.idname}) : super(key: key);
  @override
  _ListAccomplishState createState() => _ListAccomplishState(idname);
}

class NameList {
  int id;
  String name;
  String position;

  NameList({this.id, this.name, this.position});
}

class AccomplishedNameList {
  int id;
  String name;
  String position;
  String temperature;

  AccomplishedNameList({this.id, this.name, this.position, this.temperature});
}

class _ListAccomplishState extends State<ListAccomplish> {
  int idname;
  _ListAccomplishState(this.idname);

  int tabs = 0;
  List<NameList> nameList = [];
  List<AccomplishedNameList> accomplishedList = [];
  var loading = true;

  //getting the Not Completed Data
  Future<List> getJsonData() async {
    String urlApi =
        "http://203.177.199.130:8012/HDF_app/index.php?ID=" + '$idname';
    http.Response response = await http.get(urlApi);
    return json.decode(response.body);
  }

  fetchdata() async {
    if (getJsonData() != null) {
      List _jsonValue = await getJsonData();

      setState(() {
        for (var i = 0; i < _jsonValue.length; i++) {
          nameList.add(NameList(
              id: _jsonValue[i]['id'],
              name: _jsonValue[i]['name'],
              position: _jsonValue[i]['position']));
        }
        print(nameList[0].name);
        loading = false;
      });
    } else {
      print(getJsonData());
      nameList.add(NameList(id: 0, name: "empty"));
      loading = false;
    }
  }

  //Getting the Accomplished Data
  Future<List> getAccomplishedData() async {
    String urlApi =
        "http://203.177.199.130:8012/HDF_app/index.php?Accomplished=" +
            '$idname';
    http.Response response = await http.get(urlApi);
    return json.decode(response.body);
  }

  fetchAccomplishedData() async {
    if (getAccomplishedData() != null) {
      List _jsonValue2 = await getAccomplishedData();

      setState(() {
        for (var i = 0; i < _jsonValue2.length; i++) {
          accomplishedList.add(AccomplishedNameList(
              id: _jsonValue2[i]['id'],
              name: _jsonValue2[i]['name'],
              position: _jsonValue2[i]['position'],
              temperature: _jsonValue2[i]['temperature']));
        }
        print(accomplishedList[0].name);
        loading = false;
      });
    } else {
      accomplishedList.add(AccomplishedNameList(id: 0, name: "empty"));
      loading = false;
    }
  }

  fontChange() {
    if (tabs == 0) {
      return FontWeight.w800;
    } else if (tabs == 1) {
      return FontWeight.w700;
    }
  }

  fontChange1() {
    if (tabs == 1) {
      return FontWeight.w800;
    } else if (tabs == 0) {
      return FontWeight.w700;
    }
  }

  colorChange() {
    if (tabs == 0) {
      return Color.fromRGBO(245, 244, 244, 1);
    } else if (tabs == 1) {
      return Colors.white;
    }
  }

  colorChange1() {
    if (tabs == 1) {
      return Color.fromRGBO(245, 244, 244, 1);
    } else if (tabs == 0) {
      return Colors.white;
    }
  }

  borderChange() {
    if (tabs == 0) {
      return Color.fromRGBO(16, 204, 169, 1);
    } else if (tabs == 1) {
      return Colors.white;
    }
  }

  borderChange1() {
    if (tabs == 1) {
      return Color.fromRGBO(16, 204, 169, 1);
    } else if (tabs == 0) {
      return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
    fetchAccomplishedData();
  }

  @override
  Widget build(BuildContext context) {
    var notyetAccomplish = Container(
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
              margin: const EdgeInsets.only(
                  left: 10, top: 20, right: 10, bottom: 10),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 2,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 110,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Employee ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 2,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Position',
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
                  left: 15, top: 5, right: 10, bottom: 20),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: List.generate(nameList.length, (index) {
                        if (nameList[index].name == "empty" &&
                            nameList[index].id == 0)
                          return Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Complete',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(16, 204, 169, 1)),
                            ),
                          );
                        else
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HDFform(
                                            id: idname,
                                            idEmployee: nameList[index].id,
                                            name: nameList[index].name,
                                            position: nameList[index].position,
                                          )),
                                );
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0, top: 10.0),
                                          child: Text(
                                            nameList[index].name.toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Open Sans'),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Text(
                                            nameList[index].id.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Text(
                                            nameList[index].position.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: 360,
                                    height: 1,
                                    child: Container(
                                      color: Colors.black12,
                                    )),
                              ],
                            ),
                          );
                      }),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
            )
          ],
        ));
    var accomplished = Container(
        color: Color.fromRGBO(245, 244, 244, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 119),
                  width: 110,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                ),
                Container(
                  width: 160,
                  height: 2,
                  color: Color.fromRGBO(16, 204, 169, 1),
                )
              ],
            )),
            // Table header
            Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
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
                      width: 1.5,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Employee ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1.5,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 70,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Position',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 1.5,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(left: 5),
                      child: Text('Temperature',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    )
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
                  left: 10, top: 5, right: 10, bottom: 20),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: List.generate(accomplishedList.length, (index) {
                        if (accomplishedList[index].name == "empty" &&
                            accomplishedList[index].id == 0)
                          return Text('No Data.');
                        else
                          return Column(
                            children: [
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 75,
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Text(
                                          accomplishedList[index]
                                              .name
                                              .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          accomplishedList[index].id.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: 75,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          accomplishedList[index]
                                              .position
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: 101,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                          accomplishedList[index]
                                              .temperature
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: 360,
                                  height: 1,
                                  child: Container(
                                    color: Colors.black12,
                                  )),
                            ],
                          );
                      }),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
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
              child: Text('List to Accomplish',
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
                          offset: Offset(1.8, -0.7),
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
                          'Not Yet\nCompleted',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: fontChange(),
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              color: Colors.black),
                        ))),
                Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: borderChange1(),
                          spreadRadius: 2,
                          offset: Offset(0, 0),
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
                          'Accomplished',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: fontChange1(),
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              color: Colors.black),
                        )))
              ],
            )),
        if (tabs == 0) notyetAccomplish else if (tabs == 1) accomplished
      ],
    );
  }
}

// ButtonBar(
//             alignment: MainAxisAlignment.start,
//             children: [
//               FlatButton(
//                 onPressed: (){
//                   setState(() {
//                     tabs = 0;
//                   });
//                 },
//                 child: Text(
//                   'Not yet\nAccomplish',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontFamily: 'Open Sans',
//                     fontWeight: styleChange(),
//                     color: Colors.black
//                   ),
//                 ),
//                 color: Color.fromRGBO(245, 244, 244, 1), //Color.fromRGBO(16, 204, 169,1)
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.horizontal()
//                 )
//               ),
//               FlatButton(
//                 onPressed: (){
//                   setState(() {
//                     tabs = 1;
//                   });
//                 },
//                 child: Text(
//                   'Accomplished',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontFamily: 'Open Sans',
//                     fontWeight: styleChange1(),
//                     color: Colors.black
//                   ),
//                 )
//               )
//             ],
//           ),
