import 'package:beonggeatalk/screen/home.dart';
import 'package:beonggeatalk/screen/login.dart';
import 'package:beonggeatalk/screen/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginCheck extends StatefulWidget {
  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {

  bool isToken;

  read() async {
    final prefs = await SharedPreferences.getInstance();
    var parsed = json.decode(prefs.getString('user') ?? 0);
    print('read parsed=> ${parsed['token']}');
    if(parsed['token'] == '1'){
      setState(() {
        isToken = true;
      });
    }else{
      setState(() {
        isToken = false;
      });
    }
    return parsed['token'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return isToken == true ? ViewPage() : Login();
  }
}
