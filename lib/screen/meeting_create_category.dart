import 'package:beonggeatalk/screen/meeting_create_title.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         color: Colors.black38,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: Text('관심사 선택' , style: TextStyle(color: Colors.black87),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            gridView(),
          ],
        ),
      ),
    );
  }

  Widget gridView() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: gridList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                print(gridList[index]['name']);
                var category = gridList[index]['name'];
                Navigator.push(context, MaterialPageRoute(builder: (context) => MeettingCreatePage(category: category)));
              },
              child: Column(
                  children: <Widget>[
                     Expanded(
                       child: CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage(gridList[index]['photo'])),
                     ),
                    SizedBox(height: 8),
                    Text(
                      gridList[index]['name'],
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
            );
          }),
    );
  }
}
