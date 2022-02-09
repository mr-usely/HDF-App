import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hdf_app/dash.dart';
import 'package:hdf_app/Class/Servers.dart';

class HDFform extends StatefulWidget {
  final int id;
  final int idEmployee;
  final int employeeid;
  final int employeeID;
  final String name;
  final String position;
  final String encoderName;
  HDFform(
      {Key key,
      @required this.id,
      this.employeeID,
      this.employeeid,
      this.name,
      this.encoderName,
      this.position,
      this.idEmployee})
      : super(key: key);
  @override
  _HDFformState createState() => _HDFformState(
      id, employeeID, name, position, idEmployee, employeeid, encoderName);
}

class AnswerList {
  String answer;
  int index;
  AnswerList({this.answer, this.index});
}

class _HDFformState extends State<HDFform> {
  GlobalKey<FormState> _homeKey =
      GlobalKey<FormState>(debugLabel: '_homeScreenkey');

  int id; // Superior ID
  int idEmployee; //Superior Employee ID
  int employeeID; // employee ID
  int employeeid; // employee User ID
  String name; // employee name
  String position; // employee position
  String encoderName;
  _HDFformState(this.id, this.employeeID, this.name, this.position,
      this.idEmployee, this.employeeid, this.encoderName);

  //set Id for Identification
  int userId = 0;
  int empID = 0;

  TextEditingController othersController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool isTemperatureValidate = false;
  String errorMessage = "";

  String termsConditions = '';
  String secondQuestion = '0';
  String thirdQuestion = '0';
  String fourthQuestion = '0';

  int id1 = 1;
  int id2 = 2;
  int id3 = 2;
  int id4 = 2;

  int fever = 0;
  int soreThroat = 0;
  int diarrhea = 0;
  int bodyAches = 0;
  int headAches = 0;
  int dryCough = 0;
  int tirednessFatigue = 0;
  int shortnessOfBreath = 0;
  int runnyNose = 0;
  int loseOfSmellAndTaste = 0;
  int noneAbove = 0;
  int iAgree = 0;

  Map<String, bool> symptoms = {
    'Fever': false,
    'SoreThroat': false,
    'Diarrhea': false,
    'BodyAches': false,
    'HeadAches': false,
    'DryCough': false,
    'ShortnessofBreath': false,
    'TirednessFatigue': false,
    'RunnyNose': false,
    'LossofSmellTaste': false,
    'noneAbove': false,
  };

  Map<String, bool> others = {
    'others': false,
  };

  Map<String, bool> agree = {
    'IAgree': false,
  };

  List<AnswerList> nList = [
    AnswerList(
      index: 1,
      answer: "1", //yes
    ),
    AnswerList(
      index: 2,
      answer: "0", // no
    ),
    AnswerList(
      index: 3,
      answer: "I Agree",
    ),
  ];

  String hold2 = '';
  bool value;

  othersButton() {
    othersController.text;
  }

  noneOfAbove() {
    if (symptoms['noneAbove'] == true) {
      symptoms['Fever'] = false;
      symptoms['SoreThroat'] = false;
      symptoms['Diarrhea'] = false;
      symptoms['BodyAches'] = false;
      symptoms['HeadAches'] = false;
      symptoms['DryCough'] = false;
      symptoms['TirednessFatigue'] = false;
      symptoms['ShortnessofBreath'] = false;
      symptoms['RunnyNose'] = false;
      symptoms['LossofSmellTaste'] = false;
      others['others'] = false;
    }
  }

  clear() {
    symptoms['Fever'] = false;
    symptoms['SoreThroat'] = false;
    symptoms['Diarrhea'] = false;
    symptoms['BodyAches'] = false;
    symptoms['HeadAches'] = false;
    symptoms['DryCough'] = false;
    symptoms['TirednessFatigue'] = false;
    symptoms['ShortnessofBreath'] = false;
    symptoms['RunnyNose'] = false;
    symptoms['LossofSmellTaste'] = false;
    others['others'] = false;
    symptoms['noneAbove'] = false;
    agree['IAgree'] = false;
    othersController.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  // Get items and send it to database.
  getItems() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //validate
        if (_homeKey.currentState.validate()) {
          //Change user ID
          if (idEmployee != null) {
            userId = idEmployee;
          } else {
            userId = id;
          }

          agree.keys.map((String key) {
            termsConditions = (key);
            value = agree[key];
          }).toList();

          if (double.tryParse(temperatureController.text) >= 45 ||
              double.tryParse(temperatureController.text) <= 30) {
            _scrollController.animateTo(
              2.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
            setState(() {
              errorMessage =
                  "Invalid Temperature: Your temperature is too High or too Low.";
              showTooltip = true;
            });
            // showInvalidTemp(context, 'invalidTemp');
          } else if (termsConditions == 'IAgree' &&
              value == true &&
              temperatureController.text.isNotEmpty) {
            iAgree = 1;
            // hold2 = secondQuestion;
            if (symptoms['noneAbove'] == false) {
              String url = "${Servers.serverURL}/HDF_app/index.php";
              var res = await http.post(Uri.parse(url), headers: {
                "Accept": "application/json"
              }, body: {
                "HDFForm": "Form_Answer",
                "EncoderID": "$id",
                "ID": "$userId",
                "Fever": fever.toString(),
                "SoreThroat": soreThroat.toString(),
                "Diarrhea": diarrhea.toString(),
                "BodyAches": bodyAches.toString(),
                "HeadAches": headAches.toString(),
                "DryCough": dryCough.toString(),
                "TirednessFatigue": tirednessFatigue.toString(),
                "ShortnessOfBreath": shortnessOfBreath.toString(),
                "RunnyNose": runnyNose.toString(),
                "LoseOfSmellAndTaste": loseOfSmellAndTaste.toString(),
                "Others": othersController.text,
                "secondQuestion": secondQuestion,
                "thirdQuestion": thirdQuestion,
                "fourthQuestion": fourthQuestion,
                "termsConditions": iAgree.toString(),
                "temperature": temperatureController.text,
                "NoneOFTheAbove": noneAbove.toString(),
                "Encoder": encoderName,
              });

              // print(holder_1);
              print(othersController.text +
                  secondQuestion +
                  ',' +
                  thirdQuestion +
                  ',' +
                  fourthQuestion);

              if (res.body.isNotEmpty) {
                print(json.decode(res.body));
                secondQuestion = '';
                thirdQuestion = '';
                fourthQuestion = '';
                termsConditions = '';

                //var id = int.parse(name[0]);
                showSuccessDialog(context, id, encoderName);
              } else {
                print('Failed to Submit.');
              }
            } else if (others['others'] == true &&
                othersController.text.isEmpty &&
                temperatureController.text.isEmpty) {
              showAlertDialog(context);
            } else if (others['others'] == false &&
                symptoms['noneAbove'] == false) {
              showAlertDialog(context);
            } else if (others['others'] == true &&
                othersController.text.isNotEmpty) {
              iAgree = 1;
              String url = "${Servers.serverURL}/HDF_app/index.php";
              var res = await http.post(Uri.parse(url), headers: {
                "Accept": "application/json"
              }, body: {
                "HDFForm": "Form_Answer",
                "EncoderID": "$id",
                "ID": "$userId",
                "Fever": fever.toString(),
                "SoreThroat": soreThroat.toString(),
                "Diarrhea": diarrhea.toString(),
                "BodyAches": bodyAches.toString(),
                "HeadAches": headAches.toString(),
                "DryCough": dryCough.toString(),
                "TirednessFatigue": tirednessFatigue.toString(),
                "ShortnessOfBreath": shortnessOfBreath.toString(),
                "RunnyNose": runnyNose.toString(),
                "LoseOfSmellAndTaste": loseOfSmellAndTaste.toString(),
                "Others": othersController.text,
                "secondQuestion": secondQuestion,
                "thirdQuestion": thirdQuestion,
                "fourthQuestion": fourthQuestion,
                "termsConditions": iAgree.toString(),
                "temperature": temperatureController.text,
                "NoneOFTheAbove": noneAbove.toString(),
                "Encoder": encoderName,
              });
              if (res.body.isNotEmpty) {
                print(json.decode(res.body));

                secondQuestion = '';
                thirdQuestion = '';
                fourthQuestion = '';
                termsConditions = '';

                //var id = int.parse(name[0]);
                showSuccessDialog(context, id, encoderName);
              } else {
                print('Failed to Submit');
              }
            } else if (symptoms['noneAbove'] == true) {
              iAgree = 1;
              String url = "${Servers.serverURL}/HDF_app/index.php";
              var res = await http.post(Uri.parse(url), headers: {
                "Accept": "application/json"
              }, body: {
                "HDFForm": "Form_Answer",
                "EncoderID": "$id",
                "ID": "$userId",
                "Fever": fever.toString(),
                "SoreThroat": soreThroat.toString(),
                "Diarrhea": diarrhea.toString(),
                "BodyAches": bodyAches.toString(),
                "HeadAches": headAches.toString(),
                "DryCough": dryCough.toString(),
                "TirednessFatigue": tirednessFatigue.toString(),
                "ShortnessOfBreath": shortnessOfBreath.toString(),
                "RunnyNose": runnyNose.toString(),
                "LoseOfSmellAndTaste": loseOfSmellAndTaste.toString(),
                "Others": othersController.text,
                "secondQuestion": secondQuestion,
                "thirdQuestion": thirdQuestion,
                "fourthQuestion": fourthQuestion,
                "termsConditions": iAgree.toString(),
                "temperature": temperatureController.text,
                "NoneOFTheAbove": noneAbove.toString(),
                "Encoder": encoderName,
              });
              if (res.body.isNotEmpty) {
                print(json.decode(res.body));

                secondQuestion = '';
                thirdQuestion = '';
                fourthQuestion = '';
                termsConditions = '';

                //var id = int.parse(name[0]);
                showSuccessDialog(context, id, encoderName);
              } else {
                print('Failed to Submit');
              }
            } else {
              showAlertDialog(context);
            }
          } else {
            showAlertDialog(context);
          }
        } else {
          showInvalidTemp(context, 'invalidChar');
        }
      }
    } on SocketException catch (_) {
      internetAlertDialog(context);
    }
  }

  backButton() {
    if (idEmployee != null) {
      return IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(220, 16, 204, 169)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HDFhome(idname: id)),
            );
          });
    } else {
      return IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(220, 16, 204, 169)),
          onPressed: () {
            Navigator.pop(context);
          });
    }
  }

  FocusNode _focusNode;
  bool _hasInputError = false;
  String text = '';
  bool showTooltip = false;

  @override
  void initState() {
    super.initState();
    print('Form Encoder: ' + encoderName);
    //Change user ID
    if (idEmployee != null) {
      userId = idEmployee;
    } else {
      userId = id;
    }

    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      if (double.parse(text) >= 37.5 && double.parse(text) <= 45.5) {
        setState(() {
          _hasInputError = false;
          symptoms['Fever'] = true; //Check your conditions on text variable
          fever = 1;
          errorMessage =
              "Temperature is considered that you have a fever. If not sure, please retake the reading of your temperature.";
          showTooltip = true;
        });
      } else if (double.parse(text) <= 37 && symptoms['Fever'] == true) {
        showTooltip = true;
        symptoms['Fever'] = true;
        fever = 1;
      } else if (double.parse(text) <= 37 && symptoms['Fever'] == false) {
        showTooltip = false;
        symptoms['Fever'] = false;
        fever = 0;
      } else {
        setState(() {
          errorMessage = "";
          _hasInputError = false;
          showTooltip = false;
        });
      }
    });

    print(idEmployee);
    print(employeeid);
    print(name);
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    var firstcard = Column(
      children: [
        Card(
            shadowColor: Colors.black,
            elevation: 15,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 170,
                              child: Text(
                                'Employee ID: ' + '$employeeID',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 170,
                              margin: const EdgeInsets.only(bottom: 45),
                              child: Text(
                                'Name: ' + name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              child: Text(
                                'Position: ' + position,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Open Sans'),
                              ),
                            ),
                            Stack(clipBehavior: Clip.none, children: <Widget>[
                              SizedBox(
                                width: 130,
                                height: 72,
                                child: TextFormField(
                                    focusNode: _focusNode,
                                    controller: this.temperatureController,
                                    autocorrect: true,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    maxLength: 4,
                                    onChanged: (String _text) {
                                      setState(() {
                                        text = _text;
                                      });
                                    },
                                    inputFormatters: [
                                      new FilteringTextInputFormatter.deny(
                                          new RegExp('[\\,|\\-|\\ ]')),
                                    ],
                                    validator: (value) {
                                      if (value.contains(
                                          new RegExp('[\\,|\\-|\\ ]'))) {
                                        return 'Please enter valid temperature.';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Temp. Reading',
                                    )),
                              ),
                              Positioned(
                                top: 50,
                                right: 10,
                                //You can use your own custom tooltip widget over here in place of below Container
                                child: showTooltip
                                    ? Container(
                                        width: 260,
                                        height: 53,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(250, 51, 50, 50),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Center(
                                          child: Text(
                                            errorMessage,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Open Sans',
                                                fontSize: 12),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ],
    );
    var secondcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                  '1. In the past 14 days, which of the following' +
                      ' symptom(s) have you experienced, please check (✓) the' +
                      " relevant box(es). If it's not your first time filling up this" +
                      " form, kindly just indicate what you're experiencing right now.",
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: symptoms['Fever'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Fever'] = value;
                                  if (symptoms['Fever'] == true) {
                                    fever = 1;
                                  } else {
                                    fever = 0;
                                  }
                                });

                                if (symptoms['Fever'] == true &&
                                    double.parse(text) < 37.5) {
                                  setState(() {
                                    fever = 1;
                                    _hasInputError = true;
                                    errorMessage =
                                        "Invalid Temperature: Your temperature is too low to " +
                                            "declare that you have a fever.";

                                    showTooltip = true;
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                    _showToast(context);
                                  });
                                } else {
                                  _hasInputError = false;
                                  showTooltip = false;
                                }
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Fever',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['SoreThroat'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['SoreThroat'] = value;
                                  if (symptoms['SoreThroat'] == true) {
                                    soreThroat = 1;
                                  } else {
                                    soreThroat = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Sore Throat',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['Diarrhea'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Diarrhea'] = value;
                                  if (symptoms['Diarrhea'] == true) {
                                    diarrhea = 1;
                                  } else {
                                    diarrhea = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Diarrhea',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: symptoms['BodyAches'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['BodyAches'] = value;
                                  if (symptoms['BodyAches'] == true) {
                                    bodyAches = 1;
                                  } else {
                                    bodyAches = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Body Aches',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['HeadAches'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['HeadAches'] = value;
                                  if (symptoms['HeadAches'] == true) {
                                    headAches = 1;
                                  } else {
                                    headAches = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Head Aches',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['DryCough'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['DryCough'] = value;
                                  if (symptoms['DryCough'] == true) {
                                    dryCough = 1;
                                  } else {
                                    dryCough = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Dry\nCough',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: symptoms['ShortnessofBreath'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['ShortnessofBreath'] = value;
                                  if (symptoms['ShortnessofBreath'] == true) {
                                    shortnessOfBreath = 1;
                                  } else {
                                    shortnessOfBreath = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Shortness\nof Breath',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['TirednessFatigue'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['TirednessFatigue'] = value;
                                  if (symptoms['TirednessFatigue'] == true) {
                                    tirednessFatigue = 1;
                                  } else {
                                    tirednessFatigue = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Tiredness/\nFatigue',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['RunnyNose'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['RunnyNose'] = value;
                                  if (symptoms['RunnyNose'] == true) {
                                    runnyNose = 1;
                                  } else {
                                    runnyNose = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Runny\nNose',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: symptoms['LossofSmellTaste'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['LossofSmellTaste'] = value;
                                  if (symptoms['LossofSmellTaste'] == true) {
                                    loseOfSmellAndTaste = 1;
                                  } else {
                                    loseOfSmellAndTaste = 0;
                                  }
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Loss of Smell\nand Taste ',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: others['others'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  others['others'] = value;
                                });
                              } else {
                                return null;
                              }
                            }),
                        Text(
                          'Others',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Checkbox(
                            value: symptoms['noneAbove'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              setState(() {
                                symptoms['noneAbove'] = value;
                                noneOfAbove();
                                if (symptoms['noneAbove'] == true) {
                                  noneAbove = 1;
                                } else {
                                  noneAbove = 0;
                                }
                              });
                            }),
                        Text(
                          'None of\nthe Above',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        if (others['others'] == true)
                          TextFormField(
                            controller: this.othersController,
                            decoration: InputDecoration(
                              labelText: 'Other Symptoms',
                              focusColor: Color.fromARGB(220, 16, 204, 169),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ],
    );
    var thirdcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '2. Have you been in contact with a confirmed COVID-19 ' +
                        'patient in the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: nList[0].index,
                            groupValue: id2,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                secondQuestion = nList[0].answer;
                                id2 = nList[0].index;
                              });
                            }),
                        Text(
                          'YES',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Radio(
                            value: nList[1].index,
                            groupValue: id2,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                secondQuestion = nList[1].answer;
                                id2 = nList[1].index;
                              });
                            }),
                        Text(
                          'NO',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ]))
          ]),
        )
      ],
    );
    var fourthcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '3. Have you had any contact with anyone with the above ' +
                        'symptoms in the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: nList[0].index,
                            groupValue: id3,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                thirdQuestion = nList[0].answer;
                                id3 = nList[0].index;
                              });
                            }),
                        Text(
                          'YES',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Radio(
                            value: nList[1].index,
                            groupValue: id3,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                thirdQuestion = nList[1].answer;
                                id3 = nList[1].index;
                              });
                            }),
                        Text(
                          'NO',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ]))
          ]),
        )
      ],
    );
    var fifthcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                child: Text(
                    '4. Have you been to identified high risk areas of COVID-19 in' +
                        ' the past 14 days?',
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5))),
            Container(
                margin:
                    const EdgeInsets.only(left: 40.0, top: 0.0, bottom: 5.0),
                child: Column(children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: nList[0].index,
                            groupValue: id4,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                fourthQuestion = nList[0].answer;
                                id4 = nList[0].index;
                              });
                            }),
                        Text(
                          'YES',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        ),
                        Radio(
                            value: nList[1].index,
                            groupValue: id4,
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (val) {
                              setState(() {
                                fourthQuestion = nList[1].answer;
                                id4 = nList[1].index;
                              });
                            }),
                        Text(
                          'NO',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ]))
          ]),
        )
      ],
    );
    var sixthcard = Column(
      children: [
        Card(
          shadowColor: Colors.black,
          elevation: 10,
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 30),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                    'The information I have given is true, correct and complete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ))),
            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
              child: Text(
                  'I hereby authorize UNIVERSAL LEAF PHILIPPINES, INC., to collect' +
                      ' and process the data indicated herein for the purpose of effecti' +
                      'ng control of the COVID-19 infection. I understand that my perso' +
                      'nal information is protected by RA 10173, Data Privacy Act of 2012,' +
                      ' and that I am required by RA 11469, Bayanihan to Heal as One' +
                      'Act, to provide truthful information.',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 40.0, bottom: 5.0),
                child: Row(children: <Widget>[
                  Checkbox(
                      value: agree['IAgree'],
                      activeColor: Color.fromARGB(220, 16, 204, 169),
                      onChanged: (bool value) {
                        setState(() {
                          agree['IAgree'] = value;
                          if (agree['IAgree']) {
                            iAgree = 1;
                          } else {
                            iAgree = 0;
                          }
                        });
                      }),
                  Text(
                    'I AGREE',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600),
                  )
                ])),
            Container(
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: ButtonBar(children: <Widget>[
                    new SizedBox(
                      width: 163,
                      height: 40,
                      child: FlatButton(
                        onPressed: clear,
                        child: const Text('CLEAR',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Open Sans')),
                        color: Color.fromARGB(220, 16, 204, 169),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                    ),
                    new SizedBox(
                      width: 163,
                      height: 40,
                      child: FlatButton(
                        onPressed: getItems,
                        child: const Text('SAVE',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Open Sans')),
                        color: Color.fromARGB(220, 16, 204, 169),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                    )
                  ]),
                )),
          ]),
        )
      ],
    );
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: backButton(),
            brightness: Brightness.light,
            title: Text(
              'Health Declaration Form',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
          ),
          body: Form(
            key: _homeKey,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(controller: _scrollController, children: <Widget>[
                    firstcard,
                    secondcard,
                    thirdcard,
                    fourthcard,
                    fifthcard,
                    sixthcard
                  ]),
          ),
        ),
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit'),
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

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    // ignore: deprecated_member_use
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Your temperature is too low to declare a fever'),
        action: SnackBarAction(
            // ignore: deprecated_member_use
            label: 'UNDO',
            onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

internetAlertDialog(BuildContext context) {
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
    title: Text("Incomplete"),
    content: Text("Please Complete the required information!"),
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

showInvalidTemp(BuildContext context, String valid) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  validateMessage() {
    if (valid == "invalidTemp") {
      return Text("Temperature is beyond the scope.");
    } else if (valid == "invalidChar") {
      return Text("Please Check your Temperature.");
    }
  }

  AlertDialog alert = AlertDialog(
    title: Text("Invalid Temperature"),
    content: validateMessage(),
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

showSuccessDialog(BuildContext context, int id, String encoder) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Uploading, please wait...",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),
    content: SizedBox(
      width: 10,
      child: Image(
        image: AssetImage('asset/img/loading.gif'),
        width: 10,
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new HDFhome(idname: id, encoder: encoder)),
        );
      });

      return WillPopScope(child: alert, onWillPop: null);
    },
  );
}
