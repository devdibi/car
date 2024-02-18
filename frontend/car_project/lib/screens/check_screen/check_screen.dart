
import 'dart:convert';

import 'package:car_project/api_util/url.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/model/car_data.dart';
import 'package:car_project/screens/check_screen/api/car_detail.dart';
import 'package:car_project/screens/check_screen/widgets/check_card.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:car_project/screens/regist_screen/api/regist.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CheckScreen extends StatefulWidget{
  final CameraDescription? camera;
  final int? carId;

  CheckScreen({
    Key? key,
    required this.camera,
    required this.carId,
  }): super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();

}

class _CheckScreenState extends State<CheckScreen>{
  Future<Widget>? screen;
  List<int> status = [-1,-1,-1,-1];
  List<int> direction = [0,9,18,27];
  List<String> part = ["전면","좌측","후면","우측"];
  String? carType = "ETC";

  @override
  void initState(){
    super.initState();
    carDetail(context);
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<Widget>(
      future: screen,
      builder: (context, s) {
        if(s.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if(s.hasError){
          return Center(child: Text("${s.error}"));
        }else{
          return Scaffold(
            appBar: AppBar(
              title: const Text('점검 목록', style: TextStyle(fontSize: 24),),
              toolbarHeight: 60,
              leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(camera: widget.camera,)));},),
            ),
            body: Container(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child:
                // fetchData를 이용해서 데이터 로딩 후 랜더링
                ListView.builder(
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index){
                    if(index % 2 == 0){
                      int i = index ~/ 2;
                      return CheckCard(part: part[i], partNum: direction[i], camera: widget.camera, status: status[i], carType: carType!, section: i);
                    }else{
                      return Height(height: 20);
                    }
                  },
                )
            ),
          );
        }
      },
    );
  }

  Future<void> carDetail(BuildContext context) async{
    try{
      var url = Uri.parse('${URI()}/car/detail/${widget.carId}'); // POST 요청

      var response = await http.get(
        url, headers: {'Content-type': 'application/json'},
      );

      var car = json.decode(response.body)['data'];

      print(car);

      List<int> setStatus = [];

      for(int i = 0; i < 4; i++){
        setStatus.add(car['sections'][i]['checked']);
      }

      print(setStatus);

      setState(() {
        status = setStatus;
        carType = car['car_type'];
      });


    }catch(e){
      print(e);
    }
  }



}