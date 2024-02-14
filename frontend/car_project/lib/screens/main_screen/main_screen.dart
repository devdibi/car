
import 'dart:async';
import 'dart:convert';

import 'package:car_project/common_widgets/dummy_page.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/main_screen/widgets/main_card.dart';
import 'package:car_project/screens/main_screen/widgets/main_select.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Widget>>? list; // 초기 요소 미리 설정

  int pictureNum = 4; // 각도 조절

  @override
  void initState() {
    super.initState();
    list = fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    // 이미지 캐싱 => 후에는 경로 변경해서 최초 선택된 차종을 선택
    // 이미지를 받아올 때 리스트로 캐싱할 이미지 선택한다

    precacheImage(AssetImage('assets/images/car/hyundai/kona/common (4).png'), context);

    return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: FutureBuilder<List<Widget>>(
            future: list,
            builder: (context, s){
              if(s.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator()); // 랜더링 되지 않았으면 프로그래스 링 출력
              }else if (s.hasError){
                return Center(child: Text("Error : ${s.error}")); // 예기치 못한 오류
              }else{
                // 최종 결과물
                return Stack(
                  children: [
                    ListView(padding: EdgeInsets.fromLTRB(20, 10, 20, 50), children: s.data ?? []), // 하단 페이지
                    // 추가 버튼
                    Positioned(right: 10, bottom: 50,
                      child: ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CheckScreen()));}, // 생성 페이지로 이동
                          child: Container(height: 80, width: 30, padding: EdgeInsets.zero, child: Center(child: Text("+", style: TextStyle(fontSize: 50, color: Colors.white),),),),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(88, 88, 88, 100)))
                      ),
                    )
                  ],
                );
              }
            },
          )
        )
    );
  }

  Future<List<Widget>> fetchData(BuildContext context) async {
    try {
      final provider = Provider.of<Setting>(context, listen: false);

      var id = provider.user!.getId();

      var url = Uri.parse('http://127.0.0.1:5000/car/list/$id');

      var response = await http.get(url);

      List<Widget> list = [];

      List carList = json.decode(response.body)['car_list'];
      int len = json.decode(response.body)['len'];

      list.add(Container(child: Text("등록차량", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))));
      list.add(Height(height: 30),);

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
      return list;
    } catch (e) {
      print(e);
      throw(e);
    }
  }
  String convert(String dt){
    DateFormat format = DateFormat('E, d MMM yyyy HH:mm:ss zzz');
    DateTime dateTime = format.parse(dt);

    DateFormat outputFormat = DateFormat('yyyy-mm-dd');
    String date = outputFormat.format(dateTime);
    return date;
  }
}