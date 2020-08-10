import 'package:flutter/material.dart';
import 'screen/login_check.dart';


void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'BlackHanSans'
      ),
      home: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return LoginCheck();
  }
}
