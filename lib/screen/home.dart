import 'dart:convert';
import 'package:beonggeatalk/model/meeting.dart';
import 'package:beonggeatalk/screen/search_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



//나의 위치 변할때만 변경해줄것임.
String MY_LOCATION;
class _HomePageState extends State<HomePage> {

  Location location = new Location();
  bool _serviceEnabled;
  bool isDisposed = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getLocation()async{
//    final pref = await SharedPreferences.getInstance();
//    pref.remove('user');
    _locationData = await location.getLocation();
    //lat,long 출력
    print(_locationData.latitude);
    print(_locationData.longitude);
    if(_locationData != null){
      var res = await http.get('https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${_locationData.longitude}&y=${_locationData.latitude}' , headers:
      {"Authorization" : "KakaoAK 9cdfb5a704d1b32bf63b3761d1b59fc2"}
      );
////    [위치 바뀔때마다 디비에 주소 변경해주깅 테스트 코드]
//      var res = await http.get('https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=${126}&y=${36}' , headers:
//      {"Authorization" : "KakaoAK 9cdfb5a704d1b32bf63b3761d1b59fc2"}
//      );

      //요청에 응답이 정상이라면
      if(res.statusCode == 200){
        print(jsonDecode(res.body));
        var parsed = jsonDecode(res.body);
        var address = parsed['documents'][0]['address_name'];
        var location_code = parsed['documents'][0]['code'];
        print('address => ${address}');
        //계속 디비 수정할지 ??????일단 넘어가고 나중에 다시 한번 보기.

        //내 위치랑 새로받아온 위치가 다르다면 디비 업뎃
        if(MY_LOCATION != address){
          final pref = await SharedPreferences.getInstance();
          var parsed = jsonDecode(pref.getString('user'));
          var id = parsed['id'];
          print('change location get id => ${id}');

          //post 쏠때 jsonEncode(data) 포인트.
          var data = {
            "id" : id,
            "location" : address,
            "locationCode" : location_code
          };
          var res = await http.post('http://192.168.1.200:80/api/user/location', body: jsonEncode(data), headers:{'content-type':'application/json'});
          if(res.statusCode == 200){
            print('location rest api => ok');
          }
        }

        if(!isDisposed){
          setState(() {
//          MY_LOCATION = (address == null) ? '' : address;
            MY_LOCATION = address;
          });
        }
        print('${MY_LOCATION}');

      }else{
        print(jsonDecode(res.body));
      }
    }
  }

  //체크
  serviceEnable()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  //위치 권한얻기.
  hasPermission() async{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  //db에 location_code 필드 추가하기
  getMeetingCategory(String data , String photo) async{
    var _data = {
      "meetingLocationCode":"4113111200",
      "category":data
    };
    var res = await http.get('http://192.168.1.200:80/api/meeting/${'4113111200'}/${data}', headers:{'content-type':'application/json'});
    if(res.statusCode == 200){
       var parsed = jsonDecode(res.body).cast<Map<String,dynamic>>();
       var data = parsed.map((json) => Meeting.fromJson(json)).toList();
       if(parsed != null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList(meetings: data, img:photo ,home : 1)));
       }
    }else{
      print(res.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  //dispose된후에 setstate하면 에러생겨서 해놓은거.
  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          appBar(context),
          SizedBox(
              height: 140,
              child: listView(context)),
          myLocation(),
          gridView()
        ],
      )
    );
  }

  Widget appBar(BuildContext context){
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              ImageIcon(AssetImage('icons/icon128.png'),size: 28),
              Text('벙개톡',style: TextStyle(fontSize: 30),),
            ],
          ),
        ],
      ),
    );
  }

  Widget listView(BuildContext context) {
    return  ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child:  Image.asset('icons/golf1.jpeg',fit: BoxFit.fitWidth,),
            ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child:  Image.asset('icons/golf2.jpeg' , fit: BoxFit.fitWidth,),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child:  Image.asset('icons/golf3.jpeg' , fit: BoxFit.fitWidth,),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child:  Image.asset('icons/golf4.jpeg' , fit: BoxFit.fitWidth,),
          ),
          SizedBox(
            width: 10,
          )
        ]
      );
  }

  Widget myLocation() =>
   Padding(
     padding: const EdgeInsets.all(1.0),
     child: Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.baseline,
//      textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
        IconButton(
          icon: Icon(Icons.location_on),
          onPressed: (){
            print('location');
            getLocation();
          },iconSize: 22,
        ),MY_LOCATION == null ? CircularProgressIndicator() : Text('${MY_LOCATION}' , style: TextStyle(fontSize: 13),)
      ]
      ),
   );

  Widget gridView() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: gridList.length,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3 ,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2
          ),
          itemBuilder: (context, index) {
            return
               InkWell(
                 onTap: (){
                   print(gridList[index]);
                   //print(MY_LOCATION);
                   getMeetingCategory(gridList[index]['name'] , gridList[index]['photo']);
                 },
                 child: Container(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 75,
                        child: CircleAvatar(
                            radius: 5,
                            backgroundImage: AssetImage(gridList[index]['photo']
                            )
                        ),
                      ),SizedBox(height: 5),
                      Text(gridList[index]['name'],style: TextStyle(fontSize: 14),)
                    ],
                  ),
              ),
               );
          }),
    );
  }

  List gridList = [
    {"name": "여행", "photo": "icons/rocket.jpeg"},
    {"name": "맛집탐방", "photo": "icons/soju.jpg"},
    {"name": "스터디모임", "photo": "icons/study.jpeg"},
    {"name": "축구", "photo": "icons/soccer.jpeg"},
    {"name": "골프", "photo": "icons/golf.jpeg"},
    {"name": "농구", "photo": "icons/basketball.jpeg"},
    {"name": "등산", "photo": "icons/mountin.jpeg"},
    {"name": "배드민턴", "photo": "icons/Badminton.jpeg"},
    {"name": "음악", "photo": "icons/music.jpeg"},
    {"name": "테니스", "photo": "icons/tennis.png"},
    {"name": "자전거", "photo": "icons/cycle.jpeg"},
    {"name": "탁구", "photo": "icons/Pingpong.jpeg"},
  ];

}
