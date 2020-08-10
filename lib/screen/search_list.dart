import 'package:beonggeatalk/model/meeting.dart';
import 'package:beonggeatalk/screen/meeting_create_category.dart';
import 'package:flutter/material.dart';

class SearchList extends StatefulWidget {

  SearchList({this.meetings , this.img , this.home});
  var meetings;
  var img;
  var home;

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  List _meetings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _meetings = widget.meetings;
    print('init');
    print(_meetings);
  }

  func() async{
    if(_meetings.isNotEmpty){
      var a = await _meetings;
      return a;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          Text('벙개모임' , style: TextStyle(fontSize: 21 , color: Colors.black87),),
          ],
        ),
        leading: widget.home == 1 ? BackButton(
          color: Colors.black54,
        ) : null
      ),
    body: Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child:
            FutureBuilder(
              future: func(),
              builder: (context,snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: _meetings.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: CircleAvatar(
                              backgroundImage: AssetImage(widget.img)
                          ),
                          title: Text('${_meetings[index].title}'),
                          subtitle: Text('${_meetings[index].description}'),
                          trailing: Text('${_meetings[index].ParticipantsCount} 명'),
                        );
                      });
                }else if(snapshot.hasError){
                  return Center(
                    child: Text('네트워크 연결이 원활하지 않습니다.')
                  );
                }else{
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('아직 존재하는 모임이 없네요'),
                        Text('처음으로 모임을 개설해 보세요 :)'),
                        RaisedButton(
                            child: Text('모임만들기!'),
                            color: Colors.amber,
                            onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                        })
                      ],
                    ),
                  );
                }
              },
            )
          )
        ],
      ),
    ),
      floatingActionButton: widget.home != 1 ? FloatingActionButton(
          backgroundColor: Colors.amber[400],
          child: Icon(Icons.create, color: Colors.white70,),
          onPressed: (){
          print('floatingactionbtn');
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
      }) : null
    );
  }
}
