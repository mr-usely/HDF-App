import 'package:flutter/material.dart';
import 'package:HDF_App/login_page.dart';

void main() => runApp(new MyApp());

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

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogInPage(),
    );
  }
}
