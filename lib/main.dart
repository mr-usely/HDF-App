import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hdf_app/login_page.dart';
import 'package:hdf_app/hdf_form.dart';
import 'package:hdf_app/dash.dart';
import 'package:hdf_app/change-pass.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:hdf_app/verify.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:hdf_app/Class/Servers.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
      theme: ThemeData(
        brightness: Brightness.light,
        unselectedWidgetColor: Color.fromARGB(220, 16, 204, 169),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

class _DashboardState extends State<Dashboard> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  // Declare Variable for getting the device model
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidDeviceInfo;
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int network = 0;

  var changepage = false;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  //Check updated app
  //getting the Not Completed Data
  Future<String> getJsonData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String urlApi =
        "${Servers.serverURL}/HDF_app/index.php?app_update=" + '$version';
    http.Response response = await http.get(Uri.parse(urlApi));
    if (json.decode(response.body) != null) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  fetchdata() async {
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (getJsonData() != null) {
            String _jsonValue = await getJsonData();

            if (_jsonValue != null) {
              print(_jsonValue);
              if (_jsonValue != 'old version') {
                setState(() {
                  network = 1;
                });
                updateDialog(context, _jsonValue);
              } else {
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                String version = packageInfo.version;
                setState(() {
                  network = 0;
                });
                var path = await ExtStorage.getExternalStoragePublicDirectory(
                    ExtStorage.DIRECTORY_DOWNLOADS);
                final dir = Directory(path + '/ulpi_hdfv{$version}.apk');
                dir.deleteSync(recursive: true);
              }
            } else {}
          } else {}
        }
      } catch (_) {
        print(_);
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/api.txt');
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    String text;

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/api.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
      text = null;
    }
    return text;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      if (platformImei.isNotEmpty) {
        PermissionStatus permissionStorage = await Permission.storage.request();
        if (permissionStorage.isGranted) {
          print('permsion storage is granted');
        }
      }
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });
  }

// Check if the device is Connected to the internet
  checkNetwork() async {
    // get the device model.
    androidDeviceInfo = await deviceInfo.androidInfo;
    // Convert Future _read() to string
    String _text = await _read();
    print(_platformImei);
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        // if the device is connected to the internet.
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Send Device Information
          // If the user has Log for the first time then send request for the API.
          if (_text == null) {
            print('Text is null');
            setState(() {
              _text = ' ';
            });
          }

          String url = "${Servers.serverURL}/HDF_app/index.php";
          var res = await http.post(Uri.parse(url), headers: {
            "Accept": "application/json"
          }, body: {
            "APIkey": _text,
            "DeviceID": androidDeviceInfo.id,
            "DeviceName": androidDeviceInfo.model,
            "Emei": _platformImei,
          });

          print('Connecting to server');

          print(_text +
              ', ' +
              androidDeviceInfo.id +
              ', ' +
              androidDeviceInfo.model +
              ', ' +
              _platformImei);
          if (res.body.isNotEmpty) {
            print(json.decode(res.body));

            if (json.decode(res.body) == "change_device") {
              setState(() {
                changepage = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogInPage(emei: _platformImei),
                    ));
              });
            } else if (json.decode(res.body) == "none") {
              setState(() {
                changepage = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogInPage(emei: _platformImei),
                    ));
              });
            } else if (json.decode(res.body) == "false") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePass()));
            } else {
              Map user = jsonDecode(res.body);
              var response = User.fromJson(user);
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
                  MaterialPageRoute(
                      builder: (context) => HDFhome(
                          idname: id,
                          encoder: '${response.name}',
                          name: '${response.name}',
                          position: '${response.position}')),
                );
              }
            }
          } else {
            print('Cant Connect to server');
            setState(() {
              changepage = true;
            });
          }
          print('connected');
        }
      } on SocketException catch (_) {}
    } on FormatException catch (_) {
      showAlertDialog(context, "server");
      print('Check Connection failed');
    }
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // check if theres a new update in the server
        fetchdata();
      } else {
        showAlertDialog(context, "internet");
        print('Check Connection failed');
      }
    } on SocketException catch (_) {
      showAlertDialog(context, "internet");
      print('Check Connection failed');
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
    initPlatformState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    // _firebaseMessaging.getToken().then((token) {
    //   print(token);
    // });

    //_firebaseMessaging.subscribeToTopic(topic)
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ));
    Widget page = Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('asset/img/HDF-logo.png'),
              width: 120,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'ULPI Health Declaration',
                style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            )
          ],
        ),
      ),
    );

    // changePage() {
    //   if (changepage == false)
    //     return page;
    //   else
    //     return LogInPage();
    // }

    if (_source.keys.isNotEmpty) {
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.none:
          page = LogInPage(emei: _platformImei);
          break;
        case ConnectivityResult.mobile:
          if (network == 0) {
            network = 1;
            checkNetwork();
            if (changepage == true) {
              page = LogInPage(emei: _platformImei);
            }
          }
          break;
        case ConnectivityResult.wifi:
          if (network == 0) {
            network = 1;
            checkNetwork();
            if (changepage == true) {
              page = LogInPage(emei: _platformImei);
            }
          }
          break;
      }
    } else {
      showAlertDialog(context, "server");
    }
    return Scaffold(
      body: page,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivity.disposeStream();
    deactivate();
  }
}

showAlertDialog(BuildContext context, String error) {
  // set up the button
  Widget okButton1 = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okButton2 = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  _error() {
    if (error == "server") {
      return AlertDialog(
        title: Text("Can't Connect to the Server"),
        content:
            Text("Please connect to a stable internet connection network."),
        actions: [
          okButton2,
        ],
      );
    } else if (error == "internet") {
      return AlertDialog(
        title: Text("No Internet Connection"),
        content: Text("Please Connect to the Internet!"),
        actions: [
          okButton1,
        ],
      );
    }
  }

  // set up the AlertDialog
  AlertDialog alert = _error();

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Can't Connect To Server"),
    content: Text("Can't Connect to the server. Please try again"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(child: alert, onWillPop: () {});
    },
  );
}

updateDialog(BuildContext context, String appname) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Update Now"),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DailyReport(appName: appname)),
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Update Available"),
    content: Text('There was a new update from the app.'),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        child: alert,
        onWillPop: () {
          return;
        },
      );
    },
  );
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isOnline = true;
        } else
          isOnline = false;
      } on SocketException catch (_) {
        isOnline = false;
      }
    } on FormatException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
