
import 'dart:async';
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/screens/board_screen/board_screen.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/main_screen/widgets/main_card.dart';
import 'package:car_project/screens/regist_screen/regist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarScreen extends StatefulWidget{

  CarScreen({
    Key? key,
  }): super(key: key);

  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  int select = 0;
  int pictureNum = 4; // 각도 조절
  String? carNumber;
  String? date;
  String? carType;
  bool _hasCar = false;
  bool _load = false;
  int? carId;

  @override
  void initState() {
    super.initState();
    fetchData(context);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState(() {
        pictureNum = (pictureNum + 1) % 36;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // 이미지 캐싱 => 후에는 경로 변경해서 최초 선택된 차종을 선택
    // 이미지를 받아올 때 리스트로 캐싱할 이미지 선택한다

    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("대여차량", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
      ),
      body: _load ? Container(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _hasCar ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200,),
            Hero(
              tag: 'carImage',
              child: Container(
                child: Image.asset(
                  'assets/images/car/$carType/common ($pictureNum).png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(children: [
              Column(
                children: [
                  Text(carNumber!, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
                  Text(date!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("정보보기"),
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BoardScreen(carId: carId!,)));
                        }, icon: Icon(Icons.arrow_right_alt_rounded))
                        ],
                    ),
                  )
              )
            ],
            )
          ],
        ) : Center(child: Text('현재 대여중인 차량이 없습니다.')),
      ) : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: '')
        ],
      ),
    ) ;
  }

  Future<void> fetchData(BuildContext context) async {
    try {
      final provider = Provider.of<Setting>(context, listen: false);

      var id = provider.user!.getId();


      var url = Uri.parse('${URI()}/car/list/$id');

      var response = await http.get(url);

      var responseData = json.decode(response.body);

      List<Widget> list = [];

      List carList = responseData['data'];

      if (carList.isEmpty) {
        setState(() {
          _load = true;
        });
      }

      setState((){
        carType = carList[0]['car_type'];
        for(int i = 0; i < 36; i++){
          pictureNum = (pictureNum + 1) % 36;
          precacheImage(AssetImage('assets/images/car/$carType/common ($pictureNum).png'), context);
        }
        carNumber = carList[0]['car_number'];
        date = convert(carList[0]['created_at']);
        carId = carList[0]['id'];
        _hasCar = true;
        _load = true;
      });


    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // 날짜 수정하자
  String convert(String dt){
    DateFormat format = DateFormat('E, d MMM yyyy HH:mm:ss zzz'); // 입력된 날짜 형식에 맞게 DateFormat 설정
    DateTime dateTime = format.parse(dt);

    DateFormat outputFormat = DateFormat('yyyy-MM-dd'); // 출력 형식을 'yyyy-MM-dd'로 설정
    String date = outputFormat.format(dateTime);
    return date;
  }
}