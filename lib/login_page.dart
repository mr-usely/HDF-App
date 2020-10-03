import 'package:flutter/material.dart';
import 'package:HDF_App/hdf_form.dart';
import 'package:HDF_App/dash.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

final _formKey = GlobalKey<FormState>();

class User {
  final String name;
  final String id;
  final String employeeID;
  final String position;
  final String hdf;

  User(this.name, this.id, this.employeeID, this.position, this.hdf);

  User.fromJson(Map<String, dynamic> json)
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

class _LogInPageState extends State<LogInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var loading = true;

  navigate() async {
    String url = "http://203.177.199.130:8012/HDF_app/index.php";
    var res = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "Authenticate": "HDF_App_Authentication",
      "username": _usernameController.text,
      "password": _passwordController.text,
    });

    if (res.body.isNotEmpty) {
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

          Map userMap = jsonDecode(respo.body);
          var response = User.fromJson(userMap);
          // List<String> info = [
          //   '${response.id}',
          //   '${response.name}',
          //   '${response.position}'
          // ];
          print(response);
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
                      position: '${response.position}')),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HDFhome(idname: id)),
            );
          }
        } else {
          print(jsonDecode(respo.body));
          print("empty");
        }
      } else {
        print('Username or Password is Incorrect!');
        showAlertDialog(context);
      }
    } else if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showAlertDialog2(context);
    } else {
      print(json.decode(res.body));
      showAlertDialog(context);
      print('error');
    }
  }

  @override
  void initState() {
    super.initState();
    loading = false;
    //load();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : WillPopScope(
            child: Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(
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
                        height: 130,
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Card(
                            elevation: 30,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 40, right: 40),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 30, left: 40, right: 40),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscuringCharacter: '•',
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    title: Text("Incorrect Credentials."),
    content: Text("Username or Password is Incorrect!"),
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
