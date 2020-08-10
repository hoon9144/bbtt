import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'viewpage.dart';

class Login extends StatelessWidget {


  naverLogin(BuildContext context)async{
    String naver_url = "http://192.168.1.200:80/auth/naver";
    String _nToken = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => WebviewScaffold(
              url: naver_url,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: "james",
                    onMessageReceived: (JavascriptMessage result) async{
                      print('result => ${result.message}');
                      if(result.message != null) return Navigator.of(context).pop(result.message);
                      return Navigator.of(context).pop();
                    }
                ),
              ]),
            )
        )
    );

    print('_nToken => ${_nToken}');
    if(_nToken != null){
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var res = await http.get('http://192.168.1.200:80/api/user/${_nToken}');
    var parsed = jsonDecode(res.body);
    var user = parsed['user'];
    print('SharedPreferences  user  => ${parsed['user']}');
    final prefs = await _prefs;
    var _result = prefs.setString('user', jsonEncode(user)).then((bool success) => user);
    print('setString _result => ${_result}');
    return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) =>
            ViewPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 205, 33, 1.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 10),
          Logo(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              naverButton(context),
              SizedBox(height: 15,),
              facebookButton(context),
              SizedBox(height: 15,),
              kakaoButton(context),
            ],
          ),
          Footer()
        ],
      ),
    );
  }

  Widget Logo(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: ImageIcon(AssetImage('icons/icon128.png'),size: 50)
        ),
        SizedBox(height: 10),
        Text('벙개톡',style: TextStyle(fontSize: 28),)
      ],
    );
  }

  Widget naverButton(BuildContext context){
    return InkWell(
      onTap: (){
        naverLogin(context);
      },
      child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: 40,
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: new DecorationImage(
                image: new AssetImage('icons/nBtn.png'),
                fit: BoxFit.fill,
              )
          )
      ),
    );
  }

  Widget facebookButton(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width/2,
        height: 40,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: new DecorationImage(
              image: new AssetImage('icons/fBtn.png'),
              fit: BoxFit.fill,
            )
        )
    );
  }

  Widget kakaoButton(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width/2,
        height: 40,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: new DecorationImage(
              image: new AssetImage('icons/kBtn.png'),
              fit: BoxFit.fill,
            )
        )
    );
  }

  Widget Footer(){
    return Text('저수지의 개들 크루');
  }


}//

