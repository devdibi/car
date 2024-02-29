import 'dart:convert';

import 'package:car_project/common/height.dart';
import 'package:car_project/common/url.dart';
import 'package:car_project/main.dart';
import 'package:car_project/model/car_data.dart';
import 'package:car_project/screens/admin/check_screen/check_screen.dart';
import 'package:car_project/screens/admin/main_screen/admin_main_screen.dart';


import 'package:car_project/screens/admin/regist_screen/widgets/car_widget.dart';
import 'package:car_project/screens/admin/rent_screen/widgets/button_widget.dart';

import 'package:car_project/screens/admin/rent_screen/widgets/input_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';


class RentScreen extends StatefulWidget{
  final int carId;
  RentScreen({
    Key? key,
    required this.carId,
  }): super(key: key);

  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen>{
  DateTime selectedDate = DateTime.now(); // 초기 선택일을 현재 날짜로 설정

  String? carType;
  String? carNumber;
  bool _isUploading = false;
  String? customerEmail;
  DateTime? rentedAt;
  DateTime? returnedAt;
  bool _loadCar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCar();

  }

  @override
  Widget build(BuildContext context){
    return Stack(children: [
      _loadCar ? Scaffold(
        appBar: AppBar(
          title: const Text('차량 등록', style: TextStyle(fontSize: 24),),
          toolbarHeight: 50,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminMainScreen()));},),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 차량 이미지 표시 영역(3D로 자동으로 회전 할 예정)
                  Container(height:300, child: CarWidget(carType: carType),),
                  // 차량 선택 영역(차량을 선택하면 이미지 로딩 후 재 랜더링) => 이건 나중에 이쁜 UI 찾자
                  Height(height: 50,),
                  // 차량 번호 입력 영역(TextFeild)
                  RentInputWidget(onChanged: (value){
                    customerEmail = value;
                  },),
                  SizedBox(height: 50,),
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 150,
                        child: TextButton(onPressed: () => _rentStartDate(context), child: rentedAt == null ? Text("시작일 선택", style: beforeFont(),) : Text("${rentedAt!.year}년 ${rentedAt!.month}월 ${rentedAt!.day}일", style: afterFont(),) ),),
                        Text(" ~ ", style: afterFont(),),
                        Container(width: 150,
                            child: TextButton(onPressed: () => _rentEndDate(context), child: returnedAt == null ? Text("반납일 선택", style: beforeFont(),) : Text("${returnedAt!.year}년 ${returnedAt!.month}월 ${returnedAt!.day}일", style: afterFont(),) ),)
                      ],
                    ),
                    Container(width:350, height: 1, color: Colors.grey,)
                  ],),
                  Height(height: 50,),
                  ButtonWidget(
                    text: "렌트하기",
                    onPressed: () async {
                      setState(() {
                        _isUploading = true;
                      });
                      saveCar();

                      setState(() {
                        _isUploading = false;
                      });

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(carId: carId,)));
                    },),
                ],
              )
          ),
        ),
        resizeToAvoidBottomInset: true,
      ) : Scaffold(),
      _isUploading ? Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5), // 어두운 효과
          child: Center(child: CircularProgressIndicator()),
        ),
      ) : SizedBox(),
    ]
    );
  }

  Future<void> loadCar() async {
    try{
      var url = Uri.parse("${URI()}/car/detail/${widget.carId}");

      var response = await http.get(
          url, headers: {'Content-type': 'application/json'}
      );
      var responseData = json.decode(response.body)['data'];
      setState(() {
        carType = responseData['car_type'];
        _loadCar = true;
      });
    }catch(e){
      print(e);
    }
  }

  Future<void> saveCar() async{
    try{
      final provider = Provider.of<Setting>(context, listen: false);

      var url = Uri.parse("${URI()}/rent/admin/rent");

      Map<String, dynamic> body = {
        'owner_id' : provider.user!.id,
        'car_id' : widget.carId,
        'customer_email' : customerEmail,
        'rented_at' : rentedAt!.toIso8601String(),
        'returned_at' : returnedAt!.toIso8601String()
      };

      var response = await http.post(
          url, body: json.encode(body), headers: {'Content-type': 'application/json'}
      );

      if(json.decode(response.body)['code'] == 200){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminMainScreen()));
      }else{

      }
      print(json.decode(response.body));
    }catch(e){
      print(e);
    }
  }

  Future<void> _rentStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // 초기 선택일
      firstDate: DateTime.now(), // 선택 가능한 가장 이른 날짜
      lastDate: DateTime(2101), // 선택 가능한 가장 늦은 날짜
    );

    if (picked != null){
      setState(() {
        rentedAt = picked;
        selectedDate = picked;
      });
    }
  }

  Future<void> _rentEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: rentedAt, // 초기 선택일
      firstDate: rentedAt!, // 선택 가능한 가장 이른 날짜
      lastDate: DateTime(2101), // 선택 가능한 가장 늦은 날짜
    );
    if (picked != null)
      setState(() {
        returnedAt = picked;
        selectedDate = picked;
      });
  }

  TextStyle beforeFont(){
    return TextStyle(fontSize: 20, color: Colors.grey);
  }
  TextStyle afterFont(){
    return TextStyle(fontSize: 20, color: Colors.black);
  }
}
