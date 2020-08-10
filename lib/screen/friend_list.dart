import 'dart:convert';

import 'package:beonggeatalk/model/firend.dart';
import 'package:beonggeatalk/screen/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendList extends StatelessWidget {
  
  getFriend() async {
    final pref = await SharedPreferences.getInstance();
    var paresed = jsonDecode(pref.getString('user'));
    var id = paresed['id'];
    var res = await http.get('http://192.168.1.200:80/api/friend/${id}');
    var parse = jsonDecode(res.body).cast<Map<String,dynamic>>();
//    parse['Friends'] 이런식으로 접근할떄 생기는 오류
//     print(parse[0]['Friends'][0]['email']) => "soon@naver.com" 출력;
    var f = parse[0]['Friends'];
    var result = f.map((json) => Friend.fromJson(json)).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('친구' , style: TextStyle(fontSize: 21 , color: Colors.black87),),
            ],
          ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
                child:
                FutureBuilder(
                  future: getFriend(),
                  builder: (context,snapshot) {
                    var data = snapshot.data;
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            return ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: AssetImage('icons/user.png')
                              ),
                              title: Text('${data[index].name}'),
                              subtitle: Text('${data[index].introduce}'),
                            );
                          });
                    }else if(snapshot.hasError){
                      return Center(
                          child: Text('네트워크 연결이 원활하지 않습니다.')
                      );
                    }
//                    if(data == null){
//                      return Center(
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text('아직 친구가 없네요'),
//                            Text('모임활동을 통해서 친구를 사귀어보세요 :)'),
//                            RaisedButton(
//                                child: Text('우리동네 모임 보기!'),
//                                color: Colors.amber,
//                                onPressed: (){
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
//                                })
//                          ],
//                        ),
//                      );
//                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}


