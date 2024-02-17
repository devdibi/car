
import 'package:car_project/common_widgets/dummy_page.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:car_project/screens/regist_screen/widgets/button_widget.dart';
import 'package:car_project/screens/regist_screen/widgets/car_widget.dart';
import 'package:car_project/screens/regist_screen/widgets/input_widget.dart';
import 'package:car_project/screens/regist_screen/widgets/select_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class RegistScreen extends StatefulWidget{
  final CameraDescription? camera;

  RegistScreen({
    Key? key,
    required this.camera
  }): super(key: key);

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen>{
  // bool _isSelected = false;
  String? _selectItem;
  String? _carType = "ETC";

  @override
  initState(){}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('차량 등록', style: TextStyle(fontSize: 24),),
        toolbarHeight: 50,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(camera: widget.camera,)));},),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 100),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 차량 이미지 표시 영역(3D로 자동으로 회전 할 예정)
            CarWidget(carType: _carType),
            // 차량 선택 영역(차량을 선택하면 이미지 로딩 후 재 랜더링) => 이건 나중에 이쁜 UI 찾자
            SelectWidget(onSelectionChanged: (selectedItem) {setState(() {_carType = selectedItem;});},),
            Height(height: 10,),
            // 차량 번호 입력 영역(TextFeild)
            InputWidget(),
            Expanded(child: SizedBox()),
            ButtonWidget(camera: widget.camera,)
          ],
        ),
      )
    );
  }
}
