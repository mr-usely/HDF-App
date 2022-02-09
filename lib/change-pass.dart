import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hdf_app/Class/Servers.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hdf_app/dash.dart';
import 'package:hdf_app/hdf_form.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final _oldpasswordController = TextEditingController();
  final _newpasswordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _password = StreamController<String>();
  final _newpassword = StreamController<String>();
  final _confirmpassword = StreamController<String>();
  FocusNode _focus;
  FocusNode focusNode;
  bool _hasInputError = false;
  bool textChange = true;
  bool showButton = false;
  bool validateText = false;
  bool confirmText = false;
  bool buttonText = false;
  bool wrongPw = false;
  bool pwVisibility = true;
  bool newpwVisib = true;
  bool confpwVisib = true;
  bool firstText = true;
  int selectedIndex = 0;
  String text = '';
  String _platformImei = 'Unknown';
  int id;
  int employeeID;
  String name;
  String position;
  String hdf;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Future<void> initPlatformState() async {
    String platformImei;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      if (platformImei.isNotEmpty) {
        PermissionStatus permissionStorage = await Permission.storage.request();
        if (permissionStorage.isGranted) {
          print('permsion storage is granted');
        }
      }
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
    });
  }

  //
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

  // Get ID
  getID() async {
    String _text = await _read();
    String url = "${Servers.serverURL}/HDF_app/index.php";
    var res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json"
    }, body: {
      "get_emei": _text,
    });

    if (res.body.isNotEmpty) {
      Map inf = jsonDecode(res.body);
      var respo = GetID.fromJson(inf);
      setState(() {
        id = int.parse(respo.id);
        employeeID = int.parse(respo.employeeID);
        name = respo.name;
        position = respo.position;
        hdf = respo.hdf;
      });
    } else {
      print('error');
    }
  }

  // For Checking the password.
  checkOldPW() async {
    buttonText = true;
    try {
      String url = "${Servers.serverURL}/HDF_app/index.php";
      var res = await http.post(Uri.parse(url), headers: {
        "Accept": "application/json"
      }, body: {
        "validate_pass": "validate",
        "ID": "$id",
        "old_pw": _oldpasswordController.text,
      });
      if (res.body.isNotEmpty) {
        if (json.decode(res.body) == 'verified') {
          setState(() {
            wrongPw = false;

            buttonText = false;
            onTapped(1);
          });
        } else {
          setState(() {
            wrongPw = true;
            buttonText = false;
          });
        }
      } else {
        print('request failed');
      }
    } on ClientException catch (_) {
      showAlertDialog2(context);
    }
  }

  sendChangePw() async {
    try {
      String url = "${Servers.serverURL}/HDF_app/testing.php";
      var res = await http.post(Uri.parse(url), headers: {
        "Accept": "application/json"
      }, body: {
        "changepass": "validate",
        "id": "$id",
        "pw": _confirmpasswordController.text,
      });
      if (res.body.isNotEmpty) {
        if (json.decode(res.body) == 'Success') {
          if (hdf == 'true')
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HDFform(
                        id: id,
                        employeeID: employeeID,
                        name: name,
                        position: position,
                        encoderName: name,
                      )),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HDFhome(
                      idname: id,
                      encoder: name,
                      name: name,
                      position: position)),
            );
        } else {
          tryAgainDialog(context);
        }
      } else {
        print('request failed');
      }
    } on ClientException catch (_) {
      showAlertDialog2(context);
    }
  }

  //Page View Builder
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        StreamBuilder<String>(
            initialData: '',
            stream: _password.stream,
            builder: (context, oldpasswordSnapshot) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                      size: 110,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: wrongPw
                        ? Text(
                            'Wrong Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Open Sans',
                                fontSize: 12),
                          )
                        : Text(
                            'Enter your old password',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.grey.withOpacity(1),
                                fontFamily: 'Open Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                  ),

                  //Old Paswword TextFormField
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 17, right: 12),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              obscureText: pwVisibility,
                              onChanged: _password.add,
                              controller: _oldpasswordController,
                              decoration: InputDecoration(
                                  labelText: 'Old Password',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Open Sans', fontSize: 14),
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.only(top: 10),
                            icon: Icon(
                              pwVisibility
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                            onPressed: () {
                              setState(() {
                                if (pwVisibility == false)
                                  pwVisibility = true;
                                else if (pwVisibility == true)
                                  pwVisibility = false;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                  //Forgot Password

                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 30),
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 13),
                          child: GestureDetector(
                            onTap: () {
                              launch("tel://09178217909");
                            },
                            child: Text(
                              'Forgot Password',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromARGB(220, 16, 204, 169),
                                  fontFamily: 'Open Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        // Customize flat button
                        if (oldpasswordSnapshot.data.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 70, right: 0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 0),
                              child: FlatButton(
                                minWidth: 130,
                                height: 45,
                                onPressed: checkOldPW,
                                child: Text(
                                  buttonText ? 'VERIFYNG..' : 'NEXT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Open Sans',
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  ),
                                ),
                                color: Color.fromARGB(220, 16, 204, 169),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomLeft: Radius.circular(25))),
                              ),
                            ),
                          )
                        else
                          Container(),
                      ],
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<String>(
            initialData: '',
            stream: _confirmpassword.stream,
            builder: (context, confirmpasswordSnapshot) {
              return StreamBuilder<String>(
                  initialData: '',
                  stream: _newpassword.stream,
                  builder: (context, newpasswordSnapshot) {
                    if (confirmpasswordSnapshot.data !=
                            newpasswordSnapshot.data &&
                        confirmpasswordSnapshot.data.isNotEmpty) {
                      _hasInputError = true;

                      confirmText = false;
                    } else if (newpasswordSnapshot.data.isNotEmpty &&
                        confirmpasswordSnapshot.data.isEmpty) {
                      firstText = false;
                    } else if (newpasswordSnapshot.data ==
                            confirmpasswordSnapshot.data &&
                        confirmpasswordSnapshot.data.isNotEmpty &&
                        newpasswordSnapshot.data.isNotEmpty) {
                      confirmText = true;
                      _hasInputError = false;
                    } else {
                      _hasInputError = false;
                      confirmText = false;
                    }

                    return Column(
                      children: <Widget>[
                        //User Icon
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                            size: 90,
                          ),
                        ),

                        //Text
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: confirmText
                              ? Text(
                                  'Password Confirmed!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(220, 16, 204, 169),
                                      fontFamily: 'Open Sans'),
                                )
                              : firstText
                                  ? Text('Enter your new password.',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w500))
                                  : !newpasswordSnapshot.data
                                          .contains(new RegExp('[A-Z]'))
                                      ? Text('Password must have Uppercase and Lowercase',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Open Sans',
                                              fontSize: 12))
                                      : !newpasswordSnapshot.data
                                              .contains(new RegExp('[a-z]'))
                                          ? Text('Password must have Uppercase and Lowercase',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 12))
                                          : !newpasswordSnapshot.data
                                                  .contains(new RegExp('[0-9]'))
                                              ? Text('Password must have numbers and \nspecial characters.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 12))
                                              : !newpasswordSnapshot.data
                                                      .contains(new RegExp(
                                                          '[\\_|\\-|\\=@,\\.;]'))
                                                  ? Text('Password must have numbers and \nspecial characters.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 12))
                                                  : newpasswordSnapshot.data.length ==
                                                          8
                                                      ? Text(
                                                          'Your password must have at least\n8-16 characters.',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.red, fontFamily: 'Open Sans', fontSize: 12))
                                                      : textChange
                                                          ? Text(
                                                              _hasInputError
                                                                  ? "Password doesn't match"
                                                                  : 'Enter your new password',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: _hasInputError
                                                                      ? Colors
                                                                          .red
                                                                      : Colors.grey
                                                                          .withOpacity(
                                                                              1),
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              _hasInputError
                                                                  ? "Password doesn't match"
                                                                  : 'Confirm your new password',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: _hasInputError
                                                                      ? Colors
                                                                          .red
                                                                      : Colors.grey
                                                                          .withOpacity(
                                                                              1),
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                        ),

                        // New Password Text field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 205,
                                  child: TextFormField(
                                    obscureText: newpwVisib,
                                    focusNode: focusNode,
                                    onChanged: _newpassword.add,
                                    controller: _newpasswordController,
                                    decoration: InputDecoration(
                                        labelText: 'New Password',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14),
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(top: 10),
                                  icon: Icon(
                                    newpwVisib
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (newpwVisib == false)
                                        newpwVisib = true;
                                      else if (newpwVisib == true)
                                        newpwVisib = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        // Confirm Password Text field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 205,
                                  child: TextFormField(
                                    obscureText: confpwVisib,
                                    focusNode: _focus,
                                    onChanged: _confirmpassword.add,
                                    controller: _confirmpasswordController,
                                    decoration: InputDecoration(
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 14),
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.only(top: 10),
                                  icon: Icon(
                                    confpwVisib
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (confpwVisib == false)
                                        confpwVisib = true;
                                      else if (confpwVisib == true)
                                        confpwVisib = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                        // Customize flat button
                        if (newpasswordSnapshot.data ==
                                confirmpasswordSnapshot.data &&
                            confirmpasswordSnapshot.data.isNotEmpty)
                          Container(
                            height: 60,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 212, right: 10, top: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: FlatButton(
                                        minWidth: 130,
                                        height: 45,
                                        onPressed: sendChangePw,
                                        child: const Text(
                                          'NEXT',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontFamily: 'Open Sans',
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        color:
                                            Color.fromARGB(220, 16, 204, 169),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft:
                                                    Radius.circular(25))),
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        else
                          Container(),
                      ],
                    );
                  });
            })
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getID();
    focusNode = new FocusNode();
    _focus = new FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          textChange = true;
          firstText = true; //Check your conditions on text variable
        });
      }
    });

    _focus.addListener(() {
      if (_focus.hasFocus && _newpasswordController.text.isNotEmpty)
        setState(() => textChange = false);
    });
  }

  void pageChanged(int index) {
    setState(() => selectedIndex = index);
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _password.close();
    _newpassword.close();
    _confirmpassword.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(
                  'Manage Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Open Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Change your default password ' +
                        ' for\nyour security purpose.',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              height: 345,
              margin: const EdgeInsets.only(
                  top: 70, bottom: 20, right: 20, left: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 25,
                        offset: Offset(0, 0))
                  ]),
              child: buildPageView(),
            ),
          ),
        ],
      ),
    );
  }
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
    title: Text("Unable to Connect"),
    content: Text("Unable to Connect to the server. Causes are:\n" +
        "1. Slow internet connection.\n" +
        "2. The server is not active or under maintenance.\n\n" +
        "Check in a few munites and try again."),
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

tryAgainDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Invalid Password"),
    content: Text("Check your password if valid or not."),
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

forgetDialog(BuildContext context) {
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

//  change pass
class GetID {
  final String name;
  final String id;
  final String position;
  final String hdf;
  final String employeeID;

  GetID(this.id, this.employeeID, this.name, this.position, this.hdf);

  GetID.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        employeeID = json['employeeID'],
        position = json['position'],
        hdf = json['hdf'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'employeeID': employeeID,
        'position': position,
        'hdf': hdf,
      };
}
