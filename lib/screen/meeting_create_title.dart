import 'dart:convert';
import 'package:beonggeatalk/screen/search_list.dart';
import 'package:beonggeatalk/screen/viewpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeettingCreatePage extends StatefulWidget {
  MeettingCreatePage({this.category});
  String category;
  @override
  _MeettingCreatePageState createState() => _MeettingCreatePageState();
}

class _MeettingCreatePageState extends State<MeettingCreatePage> {
  Location location = new Location();
  TextEditingController titleCon = TextEditingController();
  TextEditingController descriptionCon = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String MY_LOCATION;
  String My_LOCATION_CODE;
  String title;
  String description;
  String categorydata;
  bool _serviceEnabled;
  bool isDisposed = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getLocation() async {
    _locationData = await location.getLocation();
    //lat,long 출력
    print(_locationData.latitude);
    print(_locationData.longitude);
    if (_locationData != null) {
      var res = await http.get(
          'https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${_locationData.longitude}&y=${_locationData.latitude}',
          headers: {
            "Authorization": "KakaoAK 9cdfb5a704d1b32bf63b3761d1b59fc2"
          });
      //요청에 응답이 정상이라면
      if (res.statusCode == 200) {
        print(jsonDecode(res.body));
        var parsed = jsonDecode(res.body);
        var address = parsed['documents'][0]['address_name'];
        var location_code = parsed['documents'][0]['code'];
        print('address => ${address}');
        if(!isDisposed){
          setState(() {
            MY_LOCATION = (address == null) ? '' : address;
            My_LOCATION_CODE = location_code;
          });
        }
      } else {
        print(jsonDecode(res.body));
      }
    }
  }

//체크
  serviceEnable() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

//위치 권한얻기.
  hasPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  formCheck() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    title = titleCon.text;
    description = descriptionCon.text;
    print(
        'title => ${title} subtitle => ${description} category => ${categorydata}');
    final prefs = await SharedPreferences.getInstance();
    var parsed = json.decode(prefs.getString('user') ?? 0);
    print('user id parsed=> ${parsed['id']}');
    print('user email parsed=> ${parsed['email']}');
    print('my currnt location ${MY_LOCATION}');
    print('my currnt location_code ${My_LOCATION_CODE}');

    var data = {
      "uId": parsed['id'],
      "uEmail": parsed['email'],
      "title": title,
      'description': description,
      'category': categorydata,
      "meetingLocation":MY_LOCATION,
      "meetingLocationCode":My_LOCATION_CODE
    };

    if (parsed != 0) {
      print('meeting create go?');
      var res = await http.post('http://192.168.1.200:80/api/meeting',
          body: jsonEncode(data),
          headers: {'content-type': 'application/json'});
      if (res.statusCode == 200) {
        print('insert ok');
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("방개설 완료!")));
        Future.delayed(Duration(seconds: 1)).then((value) => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()))
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    categorydata = widget.category;
    print('catagorydata => ${categorydata}');
  }



  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            '방개설',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: BackButton(
            color: Colors.black87,
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '벙개지역',
                        style: TextStyle(fontSize: 23),
                      ),
                      Spacer(),
                      myLocation(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '벙개 제목을',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        '입력해 주세요!',
                        style: TextStyle(fontSize: 23),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: titleCon,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 1,
                        maxLength: 40,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value.isNotEmpty ? null : '제목을 입력해주세요!',
                        style: TextStyle(fontSize: 13.0, color: Colors.black87),
                      ),
                      Text(
                        '벙개 모임의 간단한',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        '소개를 해주세요!',
                        style: TextStyle(fontSize: 23),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: descriptionCon,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        maxLength: 100,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value.isNotEmpty ? null : '모임의 소개를 해주세요!',
                        style: TextStyle(fontSize: 13.0, color: Colors.black87),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                              child: Text(
                                '방만들기',
                                style: TextStyle(fontSize: 20),
                              ),
                              color: Colors.amber,
                              onPressed: () {
                                formCheck();
                              })
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget myLocation() => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.baseline,
//      textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      print('location');
                      getLocation();
                    },
                    iconSize: 22,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MY_LOCATION == null
                      ? CircularProgressIndicator()
                      : Text(
                          '${MY_LOCATION}',
                          style: TextStyle(fontSize: 14),
                        )
                ],
              )
            ]),
      );
}
