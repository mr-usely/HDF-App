import 'dart:io';

import 'package:flutter/material.dart';
import 'package:HDF_App/hdf_form.dart';
import 'package:HDF_App/dash.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:url_launcher/url_launcher.dart';

class LogInPage extends StatefulWidget {
  final String emei;
  LogInPage({Key key, @required this.emei}) : super(key: key);
  @override
  _LogInPageState createState() => _LogInPageState(emei);
}

final _formKey = GlobalKey<FormState>();
MediaQueryData queryData;

class User {
  final String name;
  final String id;
  final String employeeID;
  final String position;
  final String hdf;
  final String apiKey;

  User(this.name, this.id, this.employeeID, this.position, this.hdf,
      this.apiKey);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        employeeID = json['employeeID'],
        position = json['position'],
        hdf = json['hdf'],
        apiKey = json['apiKey'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'employeeID': employeeID,
        'position': position,
        'hdf': hdf,
        'apiKey': apiKey,
      };
}

class _LogInPageState extends State<LogInPage> {
  String emei;
  _LogInPageState(this.emei);
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo;
  String _platformImei = 'Unknown';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var loading = true;

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/api.txt');
    await file.writeAsString(text);
  }

  navigate() async {
    androidDeviceInfo = await deviceInfo.androidInfo;
    try {
      String url = "http://203.177.199.130:8012/HDF_app/index.php";
      var res = await http.post(Uri.encodeFull(url), headers: {
        "Accept": "application/json"
      }, body: {
        "Authenticate": "HDF_App_Authentication",
        "username": _usernameController.text,
        "password": _passwordController.text,
        "deviceID": androidDeviceInfo.id,
        "deviceName": androidDeviceInfo.model,
        "Emei": emei,
      });

      if (_usernameController.text.isEmpty ||
          _passwordController.text.isEmpty &&
              androidDeviceInfo.id.isNotEmpty &&
              androidDeviceInfo.model.isNotEmpty) {
        showAlertDialog2(context);
      } else if (res.body.isNotEmpty) {
        print(json.decode(res.body));

        String resBody = json.decode(res.body);
        if (resBody == "HDF_Auth_Success") {
          var respo = await http.post(Uri.encodeFull(url), headers: {
            "Accept": "application/json"
          }, body: {
            "getName": _usernameController.text,
          });

          if (respo.body.isNotEmpty) {
            print(json.decode(respo.body));

            if (json.decode(respo.body) == "change_device") {
              showChangeDevice(context, androidDeviceInfo.model,
                  androidDeviceInfo.id, _usernameController.text, emei);
            } else {
              Map userMap = jsonDecode(respo.body);
              var response = User.fromJson(userMap);
              print(response);
              _write(response.apiKey);
              var id = int.parse(response.id);
              var eid = int.parse(response.employeeID);
              if (response.hdf == "true") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HDFform(
                            id: id,
                            employeeID: eid,
                            name: '${response.name}',
                            position: '${response.position}',
                            encoderName: '${response.name}',
                          )),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HDFhome(idname: id)),
                );
              }
            }
          } else {
            print(jsonDecode(respo.body));
            print("empty");
          }
        } else if (resBody == "change_device") {
          showChangeDevice(context, androidDeviceInfo.model,
              androidDeviceInfo.id, _usernameController.text, emei);
        } else if (_usernameController.text.isEmpty ||
            _passwordController.text.isEmpty) {
          showAlertDialog2(context);
        } else {
          print('Username or Password is Incorrect!');
          showAlertDialog(context, "Incorrect");
        }
      } else {
        print(json.decode(res.body));
        showAlertDialog(context, 'Incorrect');
        print('error');
      }
    } on SocketException catch (_) {
      showAlertDialog(context, 'Internet');
    }
  }

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    return loading
        ? Center(child: CircularProgressIndicator())
        : WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 0,
              ),
              body: Form(
                key: _formKey,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage("asset/img/bg.png"),
                            fit: BoxFit.cover)),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'asset/img/HDF-logo.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Health\nDeclaration',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          height: queryData.size.height / 100 * 20,
                        ),
                        Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 5,
                                      blurRadius: 20,
                                      offset: Offset(0, 0))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  margin: const EdgeInsets.only(
                                      top: 30, bottom: 12, left: 20, right: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                          labelText: 'Username',
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    margin: const EdgeInsets.only(
                                        bottom: 30, left: 20, right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscuringCharacter: '•',
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none),
                                      ),
                                    )),
                              ],
                            )),
                        Container(
                            margin: const EdgeInsets.only(left: 220, top: 15),
                            child: new SizedBox(
                              height: 40,
                              child: FlatButton(
                                onPressed: navigate,
                                child: const Text(
                                  'LOG IN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1,
                                  ),
                                ),
                                color: Color.fromARGB(220, 16, 204, 169),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(35),
                                        bottomLeft: Radius.circular(35))),
                              ),
                            ))
                      ],
                    )),
              ),
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
                  ),
                ));
  }
}

showAlertDialog(BuildContext context, String errors) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  error() {
    if (errors == 'Incorrect') {
      return AlertDialog(
        title: Text("Incorrect Credentials."),
        content: Text("Username or Password is Incorrect!"),
        actions: [
          okButton,
        ],
      );
    } else if (errors == 'Internet') {
      return AlertDialog(
        title: Text("No Internet Connection."),
        content: Text("Check your Internet Connection and try again!"),
        actions: [
          okButton,
        ],
      );
    }
  }

  // set up the AlertDialog
  AlertDialog alert = error();

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog2(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Empty Fields."),
    content: Text("Username or Password is Empty"),
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

showChangeDevice(BuildContext context, String devicename, String deviceid,
    String username, String emei) {
  _write2(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/api.txt');
    await file.writeAsString(text);
  }

  Future<List> requestValidation() async {
    String urlApi = "http://203.177.199.130:8012/HDF_app/index.php?request=" +
        '$username' +
        "&DeviceName=" +
        '$devicename' +
        "&DeviceID=" +
        '$deviceid' +
        "&Emei=" +
        '$emei';
    http.Response response = await http.get(urlApi);
    return json.decode(response.body);
  }

  getRequest() async {
    List _jsonValue = await requestValidation();
    for (var i = 0; i < _jsonValue.length; i++) {
      print(_jsonValue[i]['apikey']);
      _write2(_jsonValue[i]['apikey']);
    }
  }

  //buttons
  Widget yesButton = FlatButton(
      onPressed: () {
        getRequest();
        launch("tel://09178217909");
      },
      child: Text('Yes'));
  Widget noButton = FlatButton(
      onPressed: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Text('No'));

  Widget content2 = Container(
    height: 65,
    child: Column(
      children: <Widget>[
        Text(
            "You will be Directed to make a phone call to SSDG. Do you want to call?"),
      ],
    ),
  );

  AlertDialog alert1 = AlertDialog(
    title: Text("Incorrect Registered Device"),
    content: content2,
    actions: [yesButton, noButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      getRequest();
      return alert1;
    },
  );
}
