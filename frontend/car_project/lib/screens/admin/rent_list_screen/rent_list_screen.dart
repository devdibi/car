
import 'dart:async';
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/screens/admin/board_screen/board_screen.dart';
import 'package:car_project/screens/admin/check_screen/check_screen.dart';
import 'package:car_project/screens/admin/main_screen/widgets/main_card.dart';
import 'package:car_project/screens/admin/navigation/navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RentListScreen extends StatefulWidget{

  RentListScreen({
    Key? key,
  }): super(key: key);

  @override
  _RentListScreenState createState() => _RentListScreenState();
}

class _RentListScreenState extends State<RentListScreen> {
  Future<List<Widget>>? list; // 초기 요소 미리 설정

  int select = 0;
  int pictureNum = 4; // 각도 조절
  bool _hasCar = false;
  bool _load = false;

  @override
  void initState() {
    super.initState();
    list = fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    // 이미지 캐싱 => 후에는 경로 변경해서 최초 선택된 차종을 선택
    // 이미지를 받아올 때 리스트로 캐싱할 이미지 선택한다

    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("대여 중", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
      ),
      body:
      _load ? Stack(
        children: [
          _hasCar ?  FutureBuilder<List<Widget>>(
            future: list,
            builder: (context, s){
              if(s.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator()); // 랜더링 되지 않았으면 프로그래스 링 출력
              }else if (s.hasError){
                return Center(child: Text("Error : ${s.error}")); // 예기치 못한 오류
              }else{
                // 최종 결과물
                return
                  ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 50), children: s.data ?? []); // 하단 페이지
              }
            },
          ): Center(child: Text("대여중인 차량이 없습니다.")),
        ],
      ) : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: AdminNavigationBar(),
    );
  }

  Future<List<Widget>> fetchData(BuildContext context) async {
    try {
      final provider = Provider.of<Setting>(context, listen: false);

      var id = provider.user!.getId();

      var url = Uri.parse('${URI()}/rent/admin/list/$id');

      var response = await http.get(url);

      var responseData = json.decode(response.body);
      print(responseData);
      List<Widget> list = [];

      List carList = responseData['data'];

      if (carList.isEmpty) {
        setState(() {
          _load = true;
        });
        return list;
      }

      setState(() {
        if(carList.isNotEmpty){
          for(int i = 0; i < carList.length; i++){
            list.add(
                MainCard(carNumber: carList[i]['car_number'],
                    date: convert(carList[i]['created_at']),
                    carType: carList[i]['car_type'],
                    next: carList[i]['checked'] != 0 ? BoardScreen(carId : carList[i]['id']) : CheckScreen(carId: carList[i]['id']),
                    carId: carList[i]['id'],
                    rentable: 1,
                ),
            );

            list.add(const Height(height: 20,));
          }
        }
        _hasCar = true;
        _load = true;
      });

      return list;
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