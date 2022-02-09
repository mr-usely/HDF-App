import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hdf_app/hdf_form.dart';
import 'package:hdf_app/hdf_preview.dart';
import 'package:hdf_app/Class/Servers.dart';
import 'package:http/http.dart' as http;

class ListAccomplish extends StatefulWidget {
  final int idname;
  final String encoder;
  ListAccomplish({Key key, @required this.idname, this.encoder})
      : super(key: key);
  @override
  _ListAccomplishState createState() => _ListAccomplishState(idname, encoder);
}

MediaQueryData queryData;

class NameList {
  int id;
  int employeeID;
  String name;
  String position;

  NameList({this.id, this.name, this.position, this.employeeID});
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class AccomplishedNameList {
  int id;
  int employeeID;
  String name;
  String position;
  String temperature;

  AccomplishedNameList(
      {this.id, this.employeeID, this.name, this.position, this.temperature});
}

class _ListAccomplishState extends State<ListAccomplish> {
  int idname;
  String encoder;
  _ListAccomplishState(this.idname, this.encoder);
  final _searchController = TextEditingController();

  int tabs = 0;
  List<NameList> nameList = [];
  List<AccomplishedNameList> accomplishedList = [];
  List<ListItem> _dropdownItems = [ListItem(0, "All")];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  var loading = true;

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
      internetAlertDialog(context);
    }
  }

  //getting the Not Completed Data
  Future<List> getJsonData(String dept, String search) async {
    String urlApi = "${Servers.serverURL}/HDF_app/index.php?ID=" +
        '$idname&dept=$dept&search=$search';
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  fetchdata(String dept) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData(dept, '') != null) {
          List _jsonValue = await getJsonData(dept, '');

          if (_jsonValue != null) {
            setState(() {
              for (var i = 0; i < _jsonValue.length; i++) {
                nameList.add(NameList(
                    id: _jsonValue[i]['id'],
                    employeeID: _jsonValue[i]['employeeID'],
                    name: _jsonValue[i]['name'],
                    position: _jsonValue[i]['position']));
              }
              print(nameList[0].name);
              notAccomplishNum(nameList.length.toString(),
                  nameList[0].name.length.toString());
              loading = false;
            });
          } else {
            nameList.add(NameList(id: 0, name: "empty"));
            loading = false;
          }
        } else {
          nameList.add(NameList(id: 0, name: "empty"));
          loading = false;
        }
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  // Search Data
  searchdata(String search) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getJsonData('All', search) != null) {
          List _jsonValue = await getJsonData('All', search);

          if (_jsonValue != null) {
            setState(() {
              for (var i = 0; i < _jsonValue.length; i++) {
                nameList.add(NameList(
                    id: _jsonValue[i]['id'],
                    employeeID: _jsonValue[i]['employeeID'],
                    name: _jsonValue[i]['name'],
                    position: _jsonValue[i]['position']));
              }
              print(nameList[0].name);
              notAccomplishNum(nameList.length.toString(),
                  nameList[0].name.length.toString());
              loading = false;
            });
          } else {
            nameList.add(NameList(id: 0, name: "empty"));
            loading = false;
          }
        } else {
          nameList.add(NameList(id: 0, name: "empty"));
          loading = false;
        }
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  //Getting the Accomplished Data
  Future<List> getAccomplishedData(String dept, String search) async {
    String urlApi = "${Servers.serverURL}/HDF_app/index.php?Accomplished=" +
        '$idname&dept=$dept&search=$search';
    http.Response response = await http.get(Uri.parse(urlApi));
    return json.decode(response.body);
  }

  fetchAccomplishedData(String dept) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getAccomplishedData(dept, '') != null) {
          List _jsonValue2 = await getAccomplishedData(dept, '');

          if (_jsonValue2 != null) {
            setState(() {
              for (var i = 0; i < _jsonValue2.length; i++) {
                accomplishedList.add(AccomplishedNameList(
                    id: _jsonValue2[i]['id'],
                    employeeID: _jsonValue2[i]['employeeID'],
                    name: _jsonValue2[i]['name'],
                    position: _jsonValue2[i]['position'],
                    temperature: _jsonValue2[i]['temperature']));
              }
              print(accomplishedList[0].name);
              accomplishedNum(accomplishedList.length.toString());
              loading = false;
            });
          } else {
            accomplishedList.add(AccomplishedNameList(id: 0, name: "empty"));
            loading = false;
          }
        } else if (getAccomplishedData(dept, '') == null) {
          accomplishedList.add(AccomplishedNameList(id: 0, name: "empty"));
          loading = false;
        }
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  searchAccomData(String search) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (getAccomplishedData('All', search) != null) {
          List _jsonValue2 = await getAccomplishedData('All', search);

          if (_jsonValue2 != null) {
            setState(() {
              for (var i = 0; i < _jsonValue2.length; i++) {
                accomplishedList.add(AccomplishedNameList(
                    id: _jsonValue2[i]['id'],
                    employeeID: _jsonValue2[i]['employeeID'],
                    name: _jsonValue2[i]['name'],
                    position: _jsonValue2[i]['position'],
                    temperature: _jsonValue2[i]['temperature']));
              }
              print(accomplishedList[0].name);
              accomplishedNum(accomplishedList.length.toString());
              loading = false;
            });
          } else {
            accomplishedList.add(AccomplishedNameList(id: 0, name: "empty"));
            loading = false;
          }
        } else if (getAccomplishedData('All', search) == null) {
          accomplishedList.add(AccomplishedNameList(id: 0, name: "empty"));
          loading = false;
        }
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  notAccomplishNum(String number, String name) {
    if (number != '0' && name != 'empty')
      return Container(
        width: 60,
        height: 30,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, left: 50),
        child: Container(
          width: 32,
          height: 20,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(22), right: Radius.circular(22)),
              color: Color.fromRGBO(16, 204, 169, 1),
              border: Border.all(color: Colors.white, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Center(
              child: Text(
                number,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    else
      return Container();
  }

  accomplishedNum(String number) {
    if (number.length >= 3) {
      number = '90+';
    }
    if (number != '0')
      return Container(
        width: 85,
        height: 30,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, left: 50),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(16, 204, 169, 1),
              border: Border.all(color: Colors.white, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Center(
              child: Text(
                number,
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    else
      return Container();
  }

  bool container = true;

  @override
  void initState() {
    super.initState();
    fetchDeptdata(idname);
    fetchdata('All');
    fetchAccomplishedData('All');
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
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
    var notyetAccomplish = Container(
        //color: Color.fromRGBO(245, 244, 244, 1),
        margin: const EdgeInsets.only(top: 66),
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 244, 244, 1),
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(16, 204, 169, 1),
                    width: 2,
                    style: BorderStyle.solid))),
        child: Column(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: new Wrap(
                  spacing: 5.0, // gap between adjacent chips
                  runSpacing: 4.0,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: queryData.size.width * 0.80 / 2,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w800)),
                    ),
                    SizedBox(
                      width: 2,
                      height: 20,
                      child: Container(color: Colors.black12),
                    ),
                    Container(
                      width: queryData.size.width * 0.80 / 2,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text('Position',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w800)),
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
                                              id: idname, //superior ID
                                              idEmployee: nameList[index]
                                                  .id, //employee ID
                                              employeeID: nameList[index]
                                                  .employeeID, // usersID
                                              name: nameList[index].name, //name
                                              position:
                                                  nameList[index].position,
                                              encoderName: encoder, //position
                                            )),
                                  );
                                });
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width:
                                                queryData.size.width * 0.80 / 2,
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0, top: 10.0),
                                              child: Text(
                                                nameList[index].name.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Open Sans'),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width:
                                                queryData.size.width * 0.80 / 2,
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 0),
                                            child: Text(
                                                nameList[index]
                                                    .position
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight:
                                                        FontWeight.w600)),
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
                              ));
                      }),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
            )
          ],
        ));
    var accomplished = Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 244, 244, 1),
            border: Border(
                top: BorderSide(
                    color: Color.fromRGBO(16, 204, 169, 1),
                    width: 2,
                    style: BorderStyle.solid))),
        margin: const EdgeInsets.only(top: 66),
        child: Column(
          children: <Widget>[
            // SizedBox(
            //     child: Row(
            //   children: <Widget>[
            //     Container(
            //       margin: const EdgeInsets.only(right: 119),
            //       width: queryData.size.width / 100 * 30.5,
            //       height: 2,
            //       color: Color.fromRGBO(16, 204, 169, 1),
            //     ),
            //     Container(
            //       width: queryData.size.width / 100 * 30.5,
            //       height: 2,
            //       color: Color.fromRGBO(16, 204, 169, 1),
            //     )
            //   ],
            // )),
            // Table header
            Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 10),
              child: FittedBox(
                fit: BoxFit.contain,
                child: new Row(children: <Widget>[
                  Container(
                    width: queryData.size.width * 0.80 / 3,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text('Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w800)),
                  ),
                  // SizedBox(
                  //   width: 1.5,
                  //   height: 20,
                  //   child: Container(color: Colors.black12),
                  // ),
                  // Container(
                  //   width: queryData.size.width * 0.90 / 4,
                  //   margin: const EdgeInsets.only(left: 5, right: 5),
                  //   child: Text('Employee ID',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(fontWeight: FontWeight.w800)),
                  // ),
                  SizedBox(
                    width: 1.5,
                    height: 20,
                    child: Container(color: Colors.black12),
                  ),
                  Container(
                    width: queryData.size.width * 0.80 / 3,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text('Position',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(
                    width: 1.5,
                    height: 20,
                    child: Container(color: Colors.black12),
                  ),
                  Container(
                    width: queryData.size.width * 0.80 / 3,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text('Temperature',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w800)),
                  )
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
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HDFPreview(
                                            superiorID: idname, // Superior ID
                                            id: accomplishedList[index]
                                                .id, // users ID
                                            idEmployee: accomplishedList[index]
                                                .employeeID, //employee ID
                                            temperature: accomplishedList[index]
                                                .temperature, // users tempearature
                                            name: accomplishedList[index]
                                                .name, //name
                                            position: accomplishedList[index]
                                                .position, //position
                                            encoder: encoder,
                                          )),
                                );
                              });
                            },
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: queryData.size.width * 1 / 4,
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
                                                  fontSize: 12,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   width: queryData.size.width * 0.58 / 4,
                                        //   margin: const EdgeInsets.only(
                                        //       left: 5, right: 5),
                                        //   child: Text(
                                        //       accomplishedList[index]
                                        //           .id
                                        //           .toString(),
                                        //       textAlign: TextAlign.center,
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.w600)),
                                        // ),
                                        Container(
                                          width: queryData.size.width * 1.1 / 4,
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Text(
                                              accomplishedList[index]
                                                  .position
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Container(
                                          width:
                                              queryData.size.width * 0.75 / 4,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                              accomplishedList[index]
                                                  .temperature
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Open Sans',
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
                      }),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
            )
          ],
        ));
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: Column(children: <Widget>[
              Center(
                child: Text('List to Accomplish',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontFamily: 'Open Sans')),
              ),
            ]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 1.0,
              children: <Widget>[
                Container(
                  width: 190,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: const EdgeInsets.only(left: 10, right: 15, top: 10),
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        Container(
                          child: Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                  labelText: 'Search Name...',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Open Sans', fontSize: 12),
                                  focusedBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                        ),
                        FlatButton(
                          minWidth: 50,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            if (tabs == 0) {
                              nameList = [];
                              searchdata(_searchController.text);
                              _searchController.text = '';
                            } else if (tabs == 1) {
                              accomplishedList = [];
                              searchAccomData(_searchController.text);
                              _searchController.text = '';
                            }
                          },
                          child: Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  margin: const EdgeInsets.only(bottom: 5),
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
                            nameList = [];
                            accomplishedList = [];
                            fetchdata(_selectedItem.name);
                            fetchAccomplishedData(_selectedItem.name);
                          });
                        });
                      }),
                ),
              ]),
        ),
        Stack(clipBehavior: Clip.none, children: [
          // Tab where to Go.
          if (tabs == 0) notyetAccomplish else if (tabs == 1) accomplished,
          Container(
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    Stack(children: [
                      Container(
                          height: container ? 50 : 47,
                          width: 110,
                          margin: container
                              ? const EdgeInsets.only()
                              : const EdgeInsets.only(bottom: 1),
                          decoration: BoxDecoration(
                            color: container
                                ? Color.fromRGBO(16, 204, 169, 1)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10)),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: container
                            //         ? Color.fromRGBO(16, 204, 169, 1)
                            //         : Colors.white,
                            //     spreadRadius: 0.9,
                            //     offset: Offset(1.5, -0.70),
                            //   )
                            // ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, right: 2),
                            child: FlatButton(
                                height: 50,
                                onPressed: () {
                                  setState(() {
                                    tabs = 0;
                                    container = true;
                                  });
                                },
                                color: container
                                    ? Color.fromRGBO(245, 244, 244, 1)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(9.0)),
                                ),
                                child: Text(
                                  'Not Yet\nCompleted',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: container
                                          ? FontWeight.w800
                                          : FontWeight.w700,
                                      fontFamily: 'Open Sans',
                                      fontSize: 12,
                                      color: Colors.black),
                                )),
                          )),
                      if (nameList.isNotEmpty)
                        notAccomplishNum(
                            nameList.length.toString(), nameList[0].name)
                    ]),
                    Stack(children: [
                      Container(
                          height: container ? 47 : 50,
                          margin: container
                              ? const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 1)
                              : const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: container
                                ? Colors.white
                                : Color.fromRGBO(16, 204, 169, 1),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: container
                            //         ? Colors.white
                            //         : Color.fromRGBO(16, 204, 169, 1),
                            //     spreadRadius: 2,
                            //     offset: Offset(0, 0),
                            //   )
                            // ],
                          ),
                          child: Padding(
                            padding: container
                                ? const EdgeInsets.only(
                                    top: 2.0, right: 2.0, left: 2.0, bottom: 3)
                                : const EdgeInsets.only(
                                    top: 2.0, right: 2.0, left: 2.0),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    tabs = 1;
                                    container = false;
                                  });
                                },
                                color: container
                                    ? Colors.white
                                    : Color.fromRGBO(245, 244, 244, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                ),
                                child: Text(
                                  'Accomplished',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: container
                                          ? FontWeight.w700
                                          : FontWeight.w800,
                                      fontFamily: 'Open Sans',
                                      fontSize: 12,
                                      color: Colors.black),
                                )),
                          )),
                      accomplishedNum(accomplishedList.length.toString())
                    ])
                  ],
                ),
              ))
        ]),
      ],
    );
  }
}
