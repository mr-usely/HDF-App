import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hdf_app/Class/Servers.dart';
import 'package:http/http.dart' as http;
import 'package:hdf_app/hdf_preview.dart';

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
  int employeeID;
  String position;
  String temperature;

  HighTempList(
      {this.id, this.employeeID, this.name, this.position, this.temperature});
}

class SymptomsList {
  String name;
  int id;
  int employeeID;
  String temperature;
  String position;
  String symptoms;

  SymptomsList(
      {this.id,
      this.employeeID,
      this.temperature,
      this.name,
      this.position,
      this.symptoms});
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

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class _ReportsState extends State<Reports> {
  int idname;
  _ReportsState(this.idname);
  int tabs = 0;
  List<SummaryList> summaryList = [];
  List<HighTempList> highTempList = [];
  List<SymptomsList> symptomsList = [];
  List<ListItem> _dropdownItems = [ListItem(0, "All")];
  var loading = true;
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  //gettig the departments
  //getting the Not Completed Data
  Future<List> getDeptData(int id) async {
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?department=" + '$id';
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  fetchDeptdata(int id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getDeptData(id) != null) {
          List _jsonValue = await getDeptData(id);

          if (_jsonValue != null) {
            setState(() {
              for (var i = 0; i < _jsonValue.length; i++) {
                _dropdownItems.add(ListItem(_jsonValue[i]['value'],
                    _jsonValue[i]['department'].toString()));
              }

              // put it into the list of dropdowns.
              _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
              _selectedItem = _dropdownMenuItems[0].value;
              print(_dropdownItems[1].value.toString() +
                  ' : ' +
                  _dropdownItems[1].name);
              loading = false;
            });
          } else {
            _dropdownItems.add(ListItem(1, "empty"));
            loading = false;
          }
        } else {
          _dropdownItems.add(ListItem(1, "empty"));
          loading = false;
        }
      }
    } on SocketException catch (_) {
      showAlertDialog(context);
    }
  }

  //getting the Summary List
  Future<List> getJsonData(String dept) async {
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?Summary=$idname&dept=$dept";
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  //getting the High Temperature List
  Future<List> getJsonData2(String dept) async {
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?HighTemp=$idname&dept=$dept";
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  //getting the Symptoms List
  Future<List> getJsonData3(String dept) async {
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?Symptoms=$idname&dept=$dept";
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  // fetch Summary data from the server
  fetchdata(String dept) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData(dept) != null) {
          List _jsonValue = await getJsonData(dept);

          if (_jsonValue != null) {
            setState(() {
              for (var i = 0; i < _jsonValue.length; i++) {
                summaryList.add(SummaryList(
                    superior: _jsonValue[i]['superior'],
                    total: int.parse(_jsonValue[i]['total']),
                    notyetAcc: _jsonValue[i]['notyetAcc'],
                    accomplished: int.parse(_jsonValue[i]['accomplished']),
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
    } on SocketException catch (_) {
      showAlertDialog(context);
    }
  }

  // fetch high temp data from the server
  fetchdata2(String dept) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData2(dept) != null) {
          List _jsonValue2 = await getJsonData2(dept);

          if (_jsonValue2 != null) {
            setState(() {
              for (var i = 0; i < _jsonValue2.length; i++) {
                highTempList.add(HighTempList(
                    name: _jsonValue2[i]['name'],
                    id: _jsonValue2[i]['id'],
                    employeeID: _jsonValue2[i]['employeeID'],
                    position: _jsonValue2[i]['position'],
                    temperature: _jsonValue2[i]['temperature']));
              }
              print(highTempList[0].name);
              hightempNum(highTempList.length);
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
    } on SocketException catch (_) {
      showAlertDialog(context);
    }
  }

  // fetch symptoms data from the server
  fetchdata3(String dept) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData3(dept) != null) {
          List _jsonValue3 = await getJsonData3(dept);

          if (_jsonValue3 != null) {
            setState(() {
              for (var i = 0; i < _jsonValue3.length; i++) {
                symptomsList.add(SymptomsList(
                    name: _jsonValue3[i]['name'],
                    id: _jsonValue3[i]['id'],
                    employeeID: _jsonValue3[i]['employeeID'],
                    temperature: _jsonValue3[i]['temperature'],
                    position: _jsonValue3[i]['position'],
                    symptoms: _jsonValue3[i]['symptoms']));
              }
              print(symptomsList[0].name);
              symptomsNum(symptomsList.length);
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
    } on SocketException catch (_) {
      showAlertDialog(context);
    }
  }

  hightempNum(int number) {
    if (number != 0 && number != 1)
      return Container(
        width: 50,
        height: 30,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, left: 75),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(16, 204, 169, 1),
              border: Border.all(color: Colors.white, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    else
      return Container();
  }

  symptomsNum(int number) {
    if (number != 0 && number != 1)
      return Container(
        width: 60,
        height: 30,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, left: 50),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(16, 204, 169, 1),
              border: Border.all(color: Colors.white, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    else
      return Container();
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

  bool style = true;
  bool style1 = false;
  bool style2 = false;
  @override
  void initState() {
    super.initState();
    fetchDeptdata(idname);
    fetchdata('All');
    fetchdata2('All');
    fetchdata3('All');
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    // ignore: deprecated_member_use
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            style: TextStyle(fontSize: 12, fontFamily: 'Open Sans'),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    var summary = Container(
        margin: const EdgeInsets.only(top: 66),
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 244, 244, 1),
          border: Border(
              top: BorderSide(
                  width: 2,
                  style: BorderStyle.solid,
                  color: Color.fromRGBO(16, 204, 169, 1))),
        ),
        child: Column(
          children: <Widget>[
            // SizedBox(
            //     height: 2,
            //     width: queryData.size.width / 100 * 100,
            //     child: Container(
            //       margin: const EdgeInsets.only(left: 100),
            //       color: Color.fromRGBO(16, 204, 169, 1),
            //     )),
            // Table header
            Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: FittedBox(
                fit: BoxFit.contain,
                child: new Row(children: <Widget>[
                  Container(
                    width: queryData.size.width * 0.65 / 5,
                    margin: const EdgeInsets.only(right: 5),
                    child: Text('Dept',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(
                    width: 1,
                    height: 20,
                    child: Container(color: Colors.black12),
                  ),
                  Container(
                    width: queryData.size.width * 0.80 / 5,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text('Total Personnel',
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
                    child: Text('Not Accomplish',
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
                    width: queryData.size.width * 1.1 / 5,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text('Accomplished',
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
                                      width: queryData.size.width * 0.5 / 5,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Text(
                                          summaryList[index].total.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      width: queryData.size.width * 1.4 / 5,
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
                                      width: queryData.size.width * 1 / 5,
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
                                      width: queryData.size.width * 0.60 / 5,
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
        margin: const EdgeInsets.only(top: 66),
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 244, 244, 1),
            border: Border(
                top: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(16, 204, 169, 1)))),
        child: Column(
          children: <Widget>[
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HDFPreview(
                                          superiorID: idname,
                                          id: highTempList[index]
                                              .id, //superior ID
                                          idEmployee: highTempList[index]
                                              .employeeID, //employee ID
                                          temperature: highTempList[index]
                                              .temperature, // usersID
                                          name: highTempList[index].name, //name
                                          position: highTempList[index]
                                              .position, //position
                                        )),
                              );
                            });
                          },
                          child: Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, top: 10),
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
                          ),
                        );
                    })),
            )
          ],
        ));
    var symptoms = Container(
        margin: const EdgeInsets.only(top: 66),
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 244, 244, 1),
            border: Border(
                top: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(16, 204, 169, 1)))),
        child: Column(
          children: <Widget>[
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HDFPreview(
                                          superiorID: idname,
                                          id: symptomsList[index]
                                              .id, //superior ID
                                          idEmployee: symptomsList[index]
                                              .employeeID, //employee ID
                                          temperature: symptomsList[index]
                                              .temperature, // usersID
                                          name: symptomsList[index].name, //name
                                          position: symptomsList[index]
                                              .position, //position
                                        )),
                              );
                            });
                          },
                          child: Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, top: 10),
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
                          ),
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
          alignment: Alignment.centerRight,
          width: 95,
          margin: const EdgeInsets.only(left: 210, bottom: 5),
          child: DropdownButton<ListItem>(
              value: _selectedItem,
              items: _dropdownMenuItems,
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.filter_alt_outlined),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                  setState(() {
                    summaryList = [];
                    symptomsList = [];
                    highTempList = [];
                    fetchdata(_selectedItem.name);
                    fetchdata2(_selectedItem.name);
                    fetchdata3(_selectedItem.name);
                  });
                });
              }),
        ),
        Stack(children: [
          if (tabs == 0)
            summary
          else if (tabs == 1)
            highTemperature
          else if (tabs == 2)
            symptoms,
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: style ? 50 : 47,
                        width: 100,
                        margin: style
                            ? const EdgeInsets.only()
                            : const EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(
                          color: borderChange(),
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: style
                              ? const EdgeInsets.only(top: 2, right: 2)
                              : const EdgeInsets.only(
                                  top: 2, right: 2, bottom: 1),
                          child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  tabs = 0;
                                  style1 = false;
                                  style2 = false;
                                  style = true;
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
                              )),
                        )),
                    Stack(children: [
                      Container(
                          height: style1 ? 50 : 47,
                          margin: style1
                              ? const EdgeInsets.only(left: 5)
                              : const EdgeInsets.only(left: 5, bottom: 1),
                          decoration: BoxDecoration(
                            color: borderChange1(),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: style1
                                ? const EdgeInsets.only(
                                    top: 2, right: 2, left: 2)
                                : const EdgeInsets.only(
                                    top: 2, right: 2, left: 2, bottom: 2),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    tabs = 1;
                                    style1 = true;
                                    style2 = false;
                                    style = false;
                                  });
                                },
                                color: colorChange1(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                ),
                                child: Text(
                                  'High\nTemperature',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: fontChange1(),
                                      fontFamily: 'Open Sans',
                                      fontSize: 12,
                                      color: Colors.black),
                                )),
                          )),
                      hightempNum(highTempList.length)
                    ]),
                    Stack(children: [
                      Container(
                          height: style2 ? 50 : 47,
                          margin: style2
                              ? const EdgeInsets.only(left: 5, right: 5)
                              : const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 1),
                          decoration: BoxDecoration(
                            color: borderChange2(),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: style2
                                ? const EdgeInsets.only(
                                    top: 2, right: 2, left: 2)
                                : const EdgeInsets.only(
                                    top: 2, right: 2, left: 2, bottom: 3),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    tabs = 2;
                                    style = false;
                                    style1 = false;
                                    style2 = true;
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
                                )),
                          )),
                      symptomsNum(symptomsList.length)
                    ]),
                  ],
                ),
              )),
        ]),
      ],
    );
  }
}

showAlertDialog(BuildContext context) {
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
