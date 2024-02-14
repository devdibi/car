
import 'dart:async';
import 'dart:convert';

import 'package:car_project/common_widgets/dummy_page.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/login_screen/widgets/logo.dart';
import 'package:car_project/screens/main_screen/widgets/main_card.dart';
import 'package:car_project/screens/main_screen/widgets/main_select.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> list = [Container(child: Text("등록차량", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),Height(height: 30),]; // 초기 요소 미리 설정

  int pictureNum = 4; // 각도 조절

  @override
  void initState() {
    super.initState();
    fetchData(context);

  }

  @override
  Widget build(BuildContext context) {
    // 이미지 캐싱 => 후에는 경로 변경해서 최초 선택된 차종을 선택
    // 이미지를 받아올 때 리스트로 캐싱할 이미지 선택한다

    precacheImage(AssetImage('assets/images/car/kona/common (4).png'), context);

    return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Stack(
            children: [
              // 하단 페이지
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                      children: list,
                    ),
                  ),
                ],
              ),
              // 추가 버튼
              Positioned(
                right: 10,
                bottom: 50,
                child: ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage()));}, // 생성 페이지로 이동
                    child: Container(height: 80, width: 30, padding: EdgeInsets.zero, child: Center(child: Text("+", style: TextStyle(fontSize: 50, color: Colors.white),),),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(88, 88, 88, 100)))
                ),
              )
            ],
          ),
        )
    );
  }

  Future<void> fetchData(BuildContext context) async {
    try {
      int id = 1; // user_id 1번 사용자 => provider로 교체

      var url = Uri.parse('http://127.0.0.1:5000/list/$id');

      var response = await http.get(url);

      List carList = json.decode(response.body)['car_list'];
      int len = json.decode(response.body)['len'];

      setState(() {
        if(len != 0){
          list.add(MainSelect(carNumber: carList[0][0], date: convert(carList[0][1]), next: DummyPage()));
          list.add(Height(height: 20,));
          for(int i = 1; i < len; i++){
            list.add(MainCard(carNumber: carList[i][0], date: convert(carList[i][1]), next: DummyPage(),));
            list.add(Height(height: 20,));
          }
        }else{
          list.add(Center(child: Text("차량이 존재하지 않습니다."))); // 차량 추가하는 버튼으로 교체한다.
        }
      });

    } catch (e) {
      print(e);
    }
  }
  String convert(String dt){
    DateFormat format = DateFormat('E, d MMM yyyy HH:mm:ss zzz');
    DateTime dateTime = format.parse(dt);

    DateFormat outputFormat = DateFormat('yyyy-mm-dd');
    String date = outputFormat.format(dateTime);
    return date;
  }
  void incrementPictureNum() {
    setState(() {
      pictureNum = (pictureNum + 1) % 36; // 36까지 순환하도록 설정
    });
    print(pictureNum);
  }
}