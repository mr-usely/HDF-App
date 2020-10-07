import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Reports extends StatefulWidget {
  final int idname;
  Reports({Key key, @required this.idname}) : super(key: key);
  @override
  _ReportsState createState() => _ReportsState(idname);
}

MediaQueryData queryData;

class HighTempList {
  String name;
  int id;
  String position;
  String temperature;

  HighTempList({this.id, this.name, this.position, this.temperature});
}

class SymptomsList {
  String name;
  int id;
  String position;
  String symptoms;

  SymptomsList({this.id, this.name, this.position, this.symptoms});
}

class SummaryList {
  String superior;
  int total;
  int notyetAcc;
  int accomplished;
  String percentage;

  SummaryList(
      {this.superior,
      this.total,
      this.notyetAcc,
      this.accomplished,
      this.percentage});
}

class _ReportsState extends State<Reports> {
  int idname;
  _ReportsState(this.idname);
  int tabs = 0;
  List<SummaryList> summaryList = [];
  List<HighTempList> highTempList = [];
  List<SymptomsList> symptomsList = [];
  var loading = true;

  //getting the Summary List
  Future<List> getJsonData() async {
    String urlApi =
        "http://203.177.199.130:8012/HDF_app/index.php?Summary=" + '$idname';
    http.Response response = await http.get(urlApi);
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  //getting the High Temperature List
  Future<List> getJsonData2() async {
    String urlApi =
        "http://203.177.199.130:8012/HDF_app/index.php?HighTemp=" + '$idname';
    http.Response response = await http.get(urlApi);
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  //getting the Symptoms List
  Future<List> getJsonData3() async {
    String urlApi =
        "http://203.177.199.130:8012/HDF_app/index.php?Symptoms=" + '$idname';
    http.Response response = await http.get(urlApi);
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  // fetch high temp data from the server
  fetchdata() async {
    if (getJsonData() != null) {
      List _jsonValue = await getJsonData();

      if (_jsonValue != null) {
        setState(() {
          for (var i = 0; i < _jsonValue.length; i++) {
            summaryList.add(SummaryList(
                superior: _jsonValue[i]['superior'],
                total: _jsonValue[i]['total'],
                notyetAcc: _jsonValue[i]['notyetAcc'],
                accomplished: _jsonValue[i]['accomplished'],
                percentage: _jsonValue[i]['percentage']));
          }
          print(summaryList[0].superior);
          loading = false;
        });
      } else {
        summaryList.add(SummaryList(superior: "empty", total: 0));
        loading = false;
      }
    } else {
      summaryList.add(SummaryList(superior: "empty", total: 0));
      loading = false;
    }
  }

  // fetch high temp data from the server
  fetchdata2() async {
    if (getJsonData2() != null) {
      List _jsonValue2 = await getJsonData2();

      if (_jsonValue2 != null) {
        setState(() {
          for (var i = 0; i < _jsonValue2.length; i++) {
            highTempList.add(HighTempList(
                name: _jsonValue2[i]['name'],
                id: _jsonValue2[i]['id'],
                position: _jsonValue2[i]['position'],
                temperature: _jsonValue2[i]['temperature']));
          }
          print(highTempList[0].name);
          loading = false;
        });
      } else {
        highTempList.add(HighTempList(name: "empty", id: 0));
        loading = false;
      }
    } else {
      highTempList.add(HighTempList(name: "empty", id: 0));
      loading = false;
    }
  }

  // fetch high temp data from the server
  fetchdata3() async {
    if (getJsonData3() != null) {
      List _jsonValue3 = await getJsonData3();

      if (_jsonValue3 != null) {
        setState(() {
          for (var i = 0; i < _jsonValue3.length; i++) {
            symptomsList.add(SymptomsList(
                name: _jsonValue3[i]['name'],
                id: _jsonValue3[i]['id'],
                position: _jsonValue3[i]['position'],
                symptoms: _jsonValue3[i]['symptoms']));
          }
          print(symptomsList[0].name);
          loading = false;
        });
      } else {
        symptomsList.add(SymptomsList(name: "empty", id: 0));
        loading = false;
      }
    } else {
      symptomsList.add(SymptomsList(name: "empty", id: 0));
      loading = false;
    }
  }

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
  void initState() {
    super.initState();
    fetchdata();
    fetchdata2();
    fetchdata3();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
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
              margin:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: FittedBox(
                fit: BoxFit.contain,
                child: new Row(children: <Widget>[
                  Container(
                    width: queryData.size.width * 1 / 5,
                    margin: const EdgeInsets.only(right: 5),
                    child: Text('Department',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(
                    width: 1,
                    height: 20,
                    child: Container(color: Colors.black12),
                  ),
                  Container(
                    width: queryData.size.width * 0.70 / 5,
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
                    width: queryData.size.width * 0.95 / 5,
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
                    width: queryData.size.width * 1 / 5,
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
                    width: queryData.size.width * 0.45 / 5,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text('%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ]),
              ),
            ),
            SizedBox(
                width: 360,
                height: 1,
                child: Container(
                  color: Colors.black12,
                )),
            // Tabe Data
            Container(
              margin: const EdgeInsets.only(left: 5, right: 0, bottom: 20),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: List.generate(summaryList.length, (index) {
                      if (summaryList[index].superior == "empty" &&
                          summaryList[index].total == 0)
                        return Text('No Data.');
                      else
                        return Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: queryData.size.width * 0.80 / 5,
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Text(
                                          summaryList[index]
                                              .superior
                                              .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 1 / 5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          summaryList[index].total.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 0.95 / 5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          summaryList[index]
                                              .notyetAcc
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 1.1 / 5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          summaryList[index]
                                              .accomplished
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 0.50 / 5,
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Text(
                                          summaryList[index]
                                              .percentage
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
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
                    })),
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
              child: new Row(children: <Widget>[
                Container(
                  width: queryData.size.width * 0.80 / 3,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text('Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                // SizedBox(
                //   width: 1,
                //   height: 20,
                //   child: Container(color: Colors.black12),
                // ),
                // Container(
                //   width: queryData.size.width * 1 / 4,
                //   margin: const EdgeInsets.only(left: 5, right: 5),
                //   child: Text('Employee ID',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(fontWeight: FontWeight.w800)),
                // ),
                SizedBox(
                  width: 1,
                  height: 20,
                  child: Container(color: Colors.black12),
                ),
                Container(
                  width: queryData.size.width * 0.80 / 3,
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
                  width: queryData.size.width * 0.80 / 3,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text('Temperature',
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
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: List.generate(highTempList.length, (index) {
                      if (highTempList[index].name == "empty" &&
                          highTempList[index].id == 0)
                        return Text('No Data.');
                      else
                        return Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          highTempList[index].name.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    // Container(
                                    //   width: queryData.size.width * 0.90 / 4,
                                    //   margin: const EdgeInsets.only(
                                    //       left: 5, right: 5),
                                    //   child: Text(
                                    //       highTempList[index].id.toString(),
                                    //       textAlign: TextAlign.center,
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.w600)),
                                    // ),
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          highTempList[index]
                                              .position
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          highTempList[index]
                                              .temperature
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
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
                    })),
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
              child: new Row(children: <Widget>[
                Container(
                  width: queryData.size.width * 0.80 / 3,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text('Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                // SizedBox(
                //   width: 1,
                //   height: 20,
                //   child: Container(color: Colors.black12),
                // ),
                // Container(
                //   width: queryData.size.width * 1 / 4,
                //   margin: const EdgeInsets.only(left: 5, right: 5),
                //   child: Text('Employee ID',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(fontWeight: FontWeight.w800)),
                // ),
                SizedBox(
                  width: 1,
                  height: 20,
                  child: Container(color: Colors.black12),
                ),
                Container(
                  width: queryData.size.width * 0.80 / 3,
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
                  width: queryData.size.width * 0.80 / 3,
                  margin: const EdgeInsets.only(left: 5),
                  child: Text('Symptoms',
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
                  left: 15, right: 15, top: 10, bottom: 20),
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: List.generate(symptomsList.length, (index) {
                      if (symptomsList[index].name == "empty" &&
                          symptomsList[index].id == 0)
                        return Text('No Data.');
                      else
                        return Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          symptomsList[index].name.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    // Container(
                                    //   width: queryData.size.width * 0.80 / 4,
                                    //   margin: const EdgeInsets.only(
                                    //       left: 5, right: 5),
                                    //   child: Text(
                                    //       symptomsList[index].id.toString(),
                                    //       textAlign: TextAlign.center,
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.w600)),
                                    // ),
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          symptomsList[index]
                                              .position
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 0.80 / 3,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          symptomsList[index]
                                              .symptoms
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
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
                    })),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
