import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  SideBar({Key key, this.name, this.position}) : super(key: key);
  final String name;
  final String position;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 160,
          child: DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Menu',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w800,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name.toString(),
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              position.toString(),
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // Drawer Buttons
        Container(
          margin: const EdgeInsets.only(left: 20, top: 10),
          child: Row(
            children: <Widget>[
              // Settings Button
              Container(
                width: 125,
                height: 100,
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
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                child: FlatButton(
                  padding: EdgeInsets.only(left: -10),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.settings,
                            size: 40, color: Colors.grey.withOpacity(0.9)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
              ),

              //Log Out Button
              Container(
                width: 125,
                height: 100,
                margin: const EdgeInsets.only(left: 15.0),
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
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                child: FlatButton(
                  padding: EdgeInsets.only(left: -10),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.exit_to_app,
                            size: 40, color: Colors.grey.withOpacity(0.9)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
