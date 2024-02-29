import 'dart:async';
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/main.dart';
import 'package:car_project/screens/user/main_screen/widgets/body.dart';
import 'package:car_project/screens/user/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMainScreen extends StatefulWidget{

  UserMainScreen({
    Key? key,
  }): super(key: key);

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int pictureNum = 4; // 각도 조절
  String? carNumber;
  String? date;
  String? carType;
  int? carId;
  bool _hasCar = false;
  bool _load = false;
  DateTime? rentedAt;
  DateTime? returnedAt;

  @override
  void initState() {
    super.initState();
    fetchData(context);
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        pictureNum = (pictureNum + 1) % 36;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("대여차량", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
      ),
      body: _load ? _hasCar ? body(context, _hasCar, carType!, pictureNum, carNumber!, date!, carId!, rentedAt!, returnedAt!) : Center(child: Text("현재 렌트중인 차량이 없습니다."),): SizedBox(),
      bottomNavigationBar: UserNavigationBar(),
    ) ;
  }

  Future<void> fetchData(BuildContext context) async {
    try {
      final provider = Provider.of<Setting>(context, listen: false);

      var id = provider.user!.getId();

      var url = Uri.parse('${URI()}/rent/user/detail/$id');

      var response = await http.get(url);

      var responseData = json.decode(response.body);

      if (responseData['code'] == 204) {
        setState(() {
          _load = true;
        });
        return;
      }

      var car = responseData['data'];

      DateFormat format = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');
      DateTime rented_at = format.parse(car['rented_at']);
      DateTime returned_at = format.parse(car['returned_at']);

      setState((){
        carType = car['car_type'];
        for(int i = 0; i < 36; i++){
          pictureNum = (pictureNum + 1) % 36;
          precacheImage(AssetImage('assets/images/car/$carType/common ($pictureNum).png'), context);
        }
        carNumber = car['car_number'];
        date = convert(car['created_at']);
        carId = car['id'];
        rentedAt = rented_at;
        returnedAt = returned_at;
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