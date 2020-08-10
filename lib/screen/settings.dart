import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileLoad();
  }

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  String age = '';
  String introduce = '';

  TextEditingController nameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController introduceCont = TextEditingController();

  profileLoad() async{
    final pref = await SharedPreferences.getInstance();
    var profile = pref.getString('profile') ?? '';
    if(profile != ''){
      print('profile은 존재한다');
      var data = jsonDecode(profile);
      nameCont.text = data['name'];
      ageCont.text = data['age'];
      introduceCont.text = data['introduce'];
    }
  }


  userProfileUpdate() async{
    final pref = await SharedPreferences.getInstance();
    var parsed = jsonDecode(pref.getString('user') ?? '');
    if(parsed != ''){
      var id = parsed['id'];
      print('change location get id => ${id}');
      var data = {
        "id":id,
        "name" : name,
        "age" : age,
        "introduce" : introduce
      };
      var res = await http.post('http://192.168.1.200:80/api/user/profile', body: jsonEncode(data), headers:{'content-type':'application/json'});
      if(res.statusCode == 200){
        print('insert ok');
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("프로필 입력 완료!")));
        pref.setString('profile', jsonEncode(data));
      }
    }
  }

  Widget result(){
    return InkWell(
      onTap: () {
        print('hi 완료 클릭');
        if (!formKey.currentState.validate()) {
          return;
        }
        formKey.currentState.save();
        if(name != '' && age != '' && introduce != ''){
          print('start');
          userProfileUpdate();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '저장',
            style: TextStyle(color: Colors.black87),
          )
        ],
      ),
    );
  }


    //쿠퍼티노 액션시
    _handleClickMe() async {
    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('프로필 사진설정'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('앨범에서 사진 선택'),
              onPressed: () {
                Navigator.of(context).pop('1');
                },
            ),
            CupertinoActionSheetAction(
              child: Text('사진촬영'),
              onPressed: () {Navigator.of(context).pop('2');},
            ),
            CupertinoActionSheetAction(
              child: Text('기본사진으로 변경'),
              onPressed: () {Navigator.of(context).pop('3');},
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('취소'),
            onPressed: () {Navigator.of(context).pop();},
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          result(),
          SizedBox(
            width: 20,
          )
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: Text(
          '나의 프로필',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  getImg(),
                  Divider(),
                  profileForm(context),
                  introduceForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getImg() {
    return SizedBox(
      height: 180,
        child: Stack(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: CircleAvatar(
                backgroundColor: Colors.amber,
              ),
            ),Positioned(child: InkWell(onTap : () async {
              var a = await _handleClickMe();
              switch(a) {
                case '1' : print('일');
                break;
                case '2' : print('이');
                break;
                case '3' : print('삼');
                break;
                default: print('취소');
              }
            },child: Icon(Icons.camera_alt , size: 35,color: Colors.black38,)) , bottom: 30, right: 15,)
          ],
        )
      );
  }

  Widget profileForm(context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: TextFormField(
                controller: nameCont,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
                maxLines: 1,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                    fillColor: Colors.yellowAccent,
                    border: InputBorder.none,
                    labelText: '이름',
                    hintText: '이름',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.black87, fontSize: 21)),
                onSaved: (String name1) {
                  name = name1;
                },
                validator: (value) =>
                    value.isNotEmpty ? null : '이름을 입력해주세요!',
                style: TextStyle(fontSize: 22.0, color: Colors.black87),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              child: TextFormField(
                controller: ageCont,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.newline,
                maxLines: 1,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: '나이',
                    hintText: '나이',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.black87, fontSize: 21)),
                onSaved: (String age1) {
                  age = age1;
                },
                validator: (value) =>
                    value.isNotEmpty ? null : '나이를 입력해주세요!',
                style: TextStyle(fontSize: 22.0, color: Colors.black87),
              ),
            ),
          ],
        ));
  }

  Widget introduceForm() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 200,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: introduceCont,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 3,
            maxLength: 100,
            maxLengthEnforced: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: '간단한 자기소개',
                hintText: '본인소개를 부탁드립니다 :)',
                alignLabelWithHint: false,
                labelStyle: TextStyle(color: Colors.black87 , fontSize: 22)
            ),onSaved: (String introduce1){
            introduce = introduce1;
          },
            validator: (value) =>
            value.isNotEmpty ? null : '자기소개를 부탁드립니다!',
            style: TextStyle(fontSize: 19.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }


}
