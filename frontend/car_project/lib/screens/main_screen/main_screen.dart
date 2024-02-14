
import 'dart:convert';

import 'package:car_project/common_widgets/dummy_page.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/login_screen/widgets/logo.dart';
import 'package:car_project/screens/main_screen/widgets/main_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> list = [];

  @override
  void initState() {
    fetchData(context);

    // Backend에서 호출해와야 함
    list.addAll(
        [
          Center(child: Container(child: Logo(logo: "등록차량",),)),
          Height(height: 40),
          Container(width: 150, height: 150, child: Image.asset('assets/images/car.png'),),
          Height(height: 50)
        ]);
  }


  @override
  Widget build(BuildContext context) {
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
                child: ElevatedButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DummyPage()));
                },
                    child:
                    Container(height: 80, width: 30, padding: EdgeInsets.zero,
                      child: Center(child: Text("+", style: TextStyle(
                          fontSize: 50, color: Colors.white),),),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(88, 88, 88, 100)))
                ),
              )
            ],
          ),
        )
    );
  }

  Future<void> fetchData(BuildContext context) async {
    try {
      int id = 1;

      var url = Uri.parse('http://127.0.0.1:5000/list/$id');

      var response = await http.get(url);

      List carList = json.decode(response.body)['car_list'];
      int len = json.decode(response.body)['len'];

      for(int i = 0; i < len; i++){
        list.add(MainCard(carNumber: carList[i][0], date: convert(carList[i][1]), next: DummyPage(),));
        list.add(Height(height: 20,));
      }

      // if(response.statusCode == 200) {
      //   var responseData = json.decode(response.body);
      //   if(responseData['isLogined']){
      //     setState(() {
      //     });
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      //   }else{
      //     setState((){
      //       wrongAccount = true;
      //     });
      //   }
      //   // 응답 값을 provider에 담는다.

      // }
    } catch (e) {
      print(e);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
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