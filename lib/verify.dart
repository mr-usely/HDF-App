import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ota_update/ota_update.dart';
import 'package:platform/platform.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:install_plugin/install_plugin.dart';

class DailyReport extends StatefulWidget {
  final String appName;
  DailyReport({Key key, @required this.appName}) : super(key: key);
  @override
  _DailyReportState createState() => _DailyReportState(appName);
}

class _DailyReportState extends State<DailyReport> {
  String appName;
  _DailyReportState(this.appName);
  OtaEvent currentEvent;

  @override
  void initState() {
    super.initState();
    tryOtaUpdate();
  }

  Future<void> tryOtaUpdate() async {
    try {
      OtaUpdate()
          .execute(
        'http://203.177.199.130:8012/HDF_app/app_updates/$appName',
        destinationFilename: '$appName',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum:
            "d6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478",
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  initInstall() async {
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    if (const LocalPlatform().isAndroid) {
      InstallPlugin.installApk(path + '/$appName', 'com.example.HDF_App')
          .then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });
    }
    print('installing...');
  }

  conditioner() {
    try {
      var val = int.parse(currentEvent.value);
      double progress;
      if (currentEvent.value == 'Checksum verification failed')
        progress = 1.0;
      else
        progress = val * 0.01;
      return progress;
    } on FormatException catch (_) {
      initInstall();
      double progress = 1.0;
      return progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentEvent == null) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("asset/img/bg.png"), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('asset/img/HDF-logo.png'),
                width: 120,
              )
            ],
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WillPopScope(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/img/bg.png"), fit: BoxFit.cover)),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 243,
                    child: LinearProgressIndicator(
                      value: conditioner(),
                      backgroundColor: Color.fromARGB(100, 16, 204, 169),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(220, 16, 204, 169)),
                    ),
                  ),
                  if (currentEvent.status.toString() !=
                      'OtaStatus.CHECKSUM_ERROR')
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Downloading Update... ${currentEvent.value}%',
                        style: TextStyle(
                            color: Colors.grey, fontFamily: 'Open Sans'),
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Installing...',
                        style: TextStyle(
                            color: Colors.grey, fontFamily: 'Open Sans'),
                      ),
                    )
                ],
              ),
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
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
