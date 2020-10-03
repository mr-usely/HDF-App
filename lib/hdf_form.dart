import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:HDF_App/dash.dart';

class HDFform extends StatefulWidget {
  final int id;
  final int idEmployee;
  final int employeeid;
  final int employeeID;
  final String name;
  final String position;
  HDFform(
      {Key key,
      @required this.id,
      this.employeeID,
      this.employeeid,
      this.name,
      this.position,
      this.idEmployee})
      : super(key: key);
  @override
  _HDFformState createState() =>
      _HDFformState(id, employeeID, name, position, idEmployee, employeeid);
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
  _HDFformState(this.id, this.employeeID, this.name, this.position,
      this.idEmployee, this.employeeid);

  //set Id for Identification
  int userId = 0;
  int empID = 0;

  TextEditingController othersController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  bool _isLoading = false;
  bool isTemperatureValidate = false;

  String termsConditions = '';
  String secondQuestion = 'No';
  String thirdQuestion = 'No';
  String fourthQuestion = 'No';

  int id1 = 1;
  int id2 = 2;
  int id3 = 2;
  int id4 = 2;

  Map<String, bool> symptoms = {
    'Fever': false,
    'Sore Throat': false,
    'Diarrhea': false,
    'Body Aches': false,
    'Head Aches': false,
    'Dry Cough': false,
    'Shortness of Breath': false,
    'Tiredness/Fatigue': false,
    'Runny Nose': false,
    'Loss of Smell/Taste': false,
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
      answer: "Yes",
    ),
    AnswerList(
      index: 2,
      answer: "No",
    ),
    AnswerList(
      index: 3,
      answer: "I Agree",
    ),
  ];

  var holder_1 = [];
  String hold2 = '';
  bool value;

  othersButton() {
    othersController.text;
  }

  noneOfAbove() {
    if (symptoms['noneAbove'] == true) {
      symptoms['Fever'] = false;
      symptoms['Sore Throat'] = false;
      symptoms['Diarrhea'] = false;
      symptoms['Body Aches'] = false;
      symptoms['Head Aches'] = false;
      symptoms['Dry Cough'] = false;
      symptoms['Tiredness/Fatigue'] = false;
      symptoms['Shortness of Breath'] = false;
      symptoms['Runny Nose'] = false;
      symptoms['Loss of Smell/Taste'] = false;
      others['others'] = false;
    }
  }

  clear() {
    symptoms['Fever'] = false;
    symptoms['Sore Throat'] = false;
    symptoms['Diarrhea'] = false;
    symptoms['Body Aches'] = false;
    symptoms['Head Aches'] = false;
    symptoms['Dry Cough'] = false;
    symptoms['Tiredness/Fatigue'] = false;
    symptoms['Shortness of Breath'] = false;
    symptoms['Runny Nose'] = false;
    symptoms['Loss of Smell/Taste'] = false;
    others['others'] = false;
    symptoms['noneAbove'] = false;
    agree['IAgree'] = false;
    othersController.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  // Get items and send it to database.
  getItems() async {
    // Validate Temperature

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
        showInvalidTemp(context, 'invalidTemp');
      } else if (termsConditions == 'IAgree' &&
          value == true &&
          temperatureController.text.isNotEmpty) {
        symptoms.forEach((key, value) {
          if (value == true) {
            holder_1.add(key);
          }
        });

        //hold2 = secondQuestion;
        if (holder_1.isNotEmpty && symptoms['noneAbove'] == false) {
          String url = "http://203.177.199.130:8012/HDF_app/index.php";
          var res = await http.post(Uri.encodeFull(url), headers: {
            "Accept": "application/json"
          }, body: {
            "HDFForm": "Form_Answer",
            "ID": "$userId",
            "firstQuestion": "$holder_1",
            "Others": othersController.text,
            "secondQuestion": secondQuestion,
            "thirdQuestion": thirdQuestion,
            "fourthQuestion": fourthQuestion,
            "termsConditions": termsConditions,
            "temperature": temperatureController.text,
          });

          print(holder_1);
          print(othersController.text +
              secondQuestion +
              ',' +
              thirdQuestion +
              ',' +
              fourthQuestion);

          if (res.body.isNotEmpty) {
            print(json.decode(res.body));

            holder_1.clear();
            secondQuestion = '';
            thirdQuestion = '';
            fourthQuestion = '';
            termsConditions = '';

            //var id = int.parse(name[0]);
            showSuccessDialog(context, id);
          } else {
            print('Failed to Submit');
          }
        } else if (others['others'] == true &&
            othersController.text.isEmpty &&
            temperatureController.text.isEmpty) {
          showAlertDialog(context);
        } else if (others['others'] == false &&
            symptoms['noneAbove'] == false &&
            holder_1.isEmpty) {
          showAlertDialog(context);
        } else if (others['others'] == true &&
            othersController.text.isNotEmpty) {
          String url = "http://203.177.199.130:8012/HDF_app/index.php";
          var res = await http.post(Uri.encodeFull(url), headers: {
            "Accept": "application/json"
          }, body: {
            "HDFForm": "Form_Answer",
            "ID": "$userId",
            "firstQuestion": "$holder_1",
            "Others": othersController.text,
            "secondQuestion": secondQuestion,
            "thirdQuestion": thirdQuestion,
            "fourthQuestion": fourthQuestion,
            "termsConditions": termsConditions,
            "temperature": temperatureController.text,
          });
          if (res.body.isNotEmpty) {
            print(json.decode(res.body));

            holder_1.clear();
            secondQuestion = '';
            thirdQuestion = '';
            fourthQuestion = '';
            termsConditions = '';

            //var id = int.parse(name[0]);
            showSuccessDialog(context, id);
          } else {
            print('Failed to Submit');
          }
        } else if (symptoms['noneAbove'] == true) {
          String url = "http://203.177.199.130:8012/HDF_app/index.php";
          var res = await http.post(Uri.encodeFull(url), headers: {
            "Accept": "application/json"
          }, body: {
            "HDFForm": "Form_Answer",
            "ID": "$userId",
            "firstQuestion": "$holder_1",
            "Others": othersController.text,
            "secondQuestion": secondQuestion,
            "thirdQuestion": thirdQuestion,
            "fourthQuestion": fourthQuestion,
            "termsConditions": termsConditions,
            "temperature": temperatureController.text,
          });
          if (res.body.isNotEmpty) {
            print(json.decode(res.body));

            holder_1.clear();
            secondQuestion = '';
            thirdQuestion = '';
            fourthQuestion = '';
            termsConditions = '';

            //var id = int.parse(name[0]);
            showSuccessDialog(context, id);
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

  @override
  void initState() {
    super.initState();
    //Change user ID
    if (idEmployee != null) {
      userId = idEmployee;
    } else {
      userId = id;
    }

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
                            SizedBox(
                              width: 130,
                              height: 72,
                              child: TextFormField(
                                  controller: this.temperatureController,
                                  autocorrect: true,
                                  keyboardType: TextInputType.number,
                                  maxLengthEnforced: true,
                                  maxLength: 4,
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
                                });
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
                            value: symptoms['Sore Throat'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Sore Throat'] = value;
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
                            value: symptoms['Body Aches'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Body Aches'] = value;
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
                            value: symptoms['Head Aches'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Head Aches'] = value;
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
                            value: symptoms['Dry Cough'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Dry Cough'] = value;
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
                            value: symptoms['Shortness of Breath'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Shortness of Breath'] = value;
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
                            value: symptoms['Tiredness/Fatigue'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Tiredness/Fatigue'] = value;
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
                            value: symptoms['Runny Nose'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Runny Nose'] = value;
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
                            value: symptoms['Loss of Smell/Taste'],
                            activeColor: Color.fromARGB(220, 16, 204, 169),
                            onChanged: (bool value) {
                              if (symptoms['noneAbove'] == false) {
                                setState(() {
                                  symptoms['Loss of Smell/Taste'] = value;
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
                      'al information is protected by RA 10173, Data Privacy Act of 2012,' +
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
            title: Text(
              'Health Declaration Form',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            elevation: 10,
            backgroundColor: Colors.white,
          ),
          body: Form(
            key: _homeKey,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(children: <Widget>[
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

showSuccessDialog(BuildContext context, int id) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Uploading, please wait...",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),
    content: Image(image: AssetImage('asset/img/success.gif')),
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new HDFhome(idname: id)),
        );
      });

      return WillPopScope(child: alert, onWillPop: null);
    },
  );
}
