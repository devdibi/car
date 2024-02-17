
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/check_screen/widgets/check_card.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CheckScreen extends StatefulWidget{
  final CameraDescription? camera;

  CheckScreen({
    Key? key,
    required this.camera
  }): super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();

}

class _CheckScreenState extends State<CheckScreen>{
  @override
  void initState(){

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
        child:
          // fetchData를 이용해서 데이터 로딩 후 랜더링
          ListView(
            children: [
              CheckCard(part: "전면",partNum: 0, camera: widget.camera,),
              Height(height: 20),
              CheckCard(part: "좌측",partNum: 9, camera: widget.camera,),
              Height(height: 20),
              CheckCard(part: "후면",partNum: 18, camera: widget.camera,),
              Height(height: 20),
              CheckCard(part: "우측",partNum: 27, camera: widget.camera,),
              Height(height: 20),
            ],
          )
      ),
    );
  }

  // Future<List<Widget>> fetchData(){
  //
  //   // Text
  //   // Image
  //   // Info
  // }


}