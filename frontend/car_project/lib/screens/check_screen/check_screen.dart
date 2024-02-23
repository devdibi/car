
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/screens/check_screen/api/complete.dart';
import 'package:car_project/screens/check_screen/widgets/check_card.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
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
  Future<List<Widget>>? list;
  List<int> status = [-1,-1,-1,-1];
  List<int> direction = [0,9,18,27];
  List<String> part = ["전면","좌측","후면","우측"];
  String? carType = "ETC";

  @override
  void initState(){
    super.initState();
    list = carDetail(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('점검 목록', style: TextStyle(fontSize: 24),),
        toolbarHeight: 60,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(camera: widget.camera,)));},),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: FutureBuilder<List<Widget>>(
            future: list,
            builder: (context, s) {
              if(s.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else if(s.hasError){
                return Center(child: Text("${s.error}"));
              }else{
                return ListView(children: s.data ?? [],);
              }
            },
          )
        // fetchData를 이용해서 데이터 로딩 후 랜더링
      ),
    );
  }


  bool isCompleted(){
    for(int i = 0; i < 4; i++){
      if(status[i] == 0) return false;
    }
    return true;
  }

  Future<List<Widget>> carDetail(BuildContext context) async{
    try{
      var url = Uri.parse('${URI()}/car/detail/${widget.carId}'); // POST 요청

      var response = await http.get(
        url, headers: {'Content-type': 'application/json'},
      );

      var car = json.decode(response.body)['data'];

      print(car);

      List<int> setStatus = [];

      // 상태를 확인한다.
      for(int i = 0; i < 4; i++){
        setStatus.add(car['sections'][i]['checked']);
      }

      // 상태 적용
      setState(() {
        status = setStatus;
        carType = car['car_type'];
      });

      // section 별로 파손 여부를 넣는다.

      // 카드 리스트 생성
      List<Widget> list = [];

      for(int index = 0; index < 8; index++){
        if(index % 2 == 0){
          int i = index ~/ 2;
          list.add(CheckCard(part: part[i], partNum: direction[i], camera: widget.camera, status: status[i], carType: carType!, sectionId: car['sections'][i]['id'], section: car['sections'][i]['section'], carId: widget.carId!));
        }else{
          list.add(Height(height: 20));
        }
      }

      if(isCompleted()) {
        list.add(
            ElevatedButton(
              onPressed: () async{
                await complete(widget.carId!);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(camera: widget.camera)));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
                  fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  elevation: MaterialStateProperty.all(2)
              ),
              child: Text("저장하기", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ));
      }
      return list;
    }catch(e){
      print(e);
      rethrow;
    }
  }



}
