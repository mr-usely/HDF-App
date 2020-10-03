import 'package:flutter/material.dart';

MediaQueryData queryData;

class ScreenSized extends StatefulWidget {
  @override
  _ScreenSizedState createState() => _ScreenSizedState();
}

class _ScreenSizedState extends State<ScreenSized> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    print(queryData.size.width * 0.90);
    return Scaffold(
      body: Container(
        width: queryData.size.width * 0.95 / 3,
        height: 200,
        decoration: BoxDecoration(color: Colors.blue),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
          ),
          width: 20,
          height: 20,
          child: Row(
            children: [
              Text(
                'Sized',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
