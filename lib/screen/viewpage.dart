import 'dart:convert';
import 'package:beonggeatalk/model/meeting.dart';
import 'package:beonggeatalk/screen/chat_list.dart';
import 'package:beonggeatalk/screen/friend_list.dart';
import 'package:beonggeatalk/screen/home.dart';
import 'package:beonggeatalk/screen/search_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'settings.dart';

class ViewPage extends StatefulWidget {
  @override
  _ViewPageState createState() => _ViewPageState();
}



class _ViewPageState extends State<ViewPage> {

//  final List<Widget> list = [HomePage(), FriendList(), SearchList(meetings: data,img: imgg), ChatList(),Settings()];
  List<Widget> list;
  bool isDisposed = false;
  int _currentIndex = 0;
  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    list = [HomePage(), FriendList(), SearchList(meetings: 1,img: 'icons/icon128.png'), ChatList(),Settings()];
    getAllMeetings();
  }

  getAllMeetings() async{
    var res = await http.get('http://192.168.1.200:80/api/meeting');
    if(res.statusCode == 200){
      var parsed = jsonDecode(res.body).cast<Map<String,dynamic>>();
      var dataa = parsed.map((json) => Meeting.fromJson(json)).toList();
//      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList(meetings: dataa, img: 'icons/icon128.png',)));
      list = [HomePage(), FriendList(), SearchList(meetings: dataa,img: 'icons/icon128.png'), ChatList(),Settings()];
    }
  }



  Widget appBar(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          ImageIcon(AssetImage('icons/icon128.png'),size: 28),
          Text('번개톡',style: TextStyle(fontSize: 30),),
        ],
      ),
    );
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
      body:
            list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  '홈',
                  style: TextStyle(fontSize: 10),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text(
                  '친구목록',
                  style: TextStyle(fontSize: 10),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title:Text(
                    '벙개찾기',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('icons/icon128.png')),
                title: Text(
                  '내 벙개',
                  style: TextStyle(fontSize: 10),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_emoticon),
                title: Text(
                  '설정',
                  style: TextStyle(fontSize: 10),
                ))
          ]),
    );
  }

}

