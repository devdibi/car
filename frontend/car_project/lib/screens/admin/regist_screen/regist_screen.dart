import 'package:car_project/common/height.dart';
import 'package:car_project/model/car_data.dart';
import 'package:car_project/screens/admin/check_screen/check_screen.dart';
import 'package:car_project/screens/admin/main_screen/admin_main_screen.dart';
import 'package:car_project/screens/admin/regist_screen/api/regist.dart';
import 'package:car_project/screens/admin/regist_screen/widgets/button_widget.dart';
import 'package:car_project/screens/admin/regist_screen/widgets/car_widget.dart';
import 'package:car_project/screens/admin/regist_screen/widgets/input_widget.dart';
import 'package:car_project/screens/admin/regist_screen/widgets/select_widget.dart';

import 'package:flutter/material.dart';


class RegistScreen extends StatefulWidget{

  RegistScreen({
    Key? key,
  }): super(key: key);

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen>{
  // bool _isSelected = false;
  String? carType = "TUCSON";
  String? carNumber;
  bool _isUploading = false;

  @override
  initState(){super.initState();}

  @override
  Widget build(BuildContext context){
    return Stack(children: [
      Scaffold(
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
                children: [
                  // 차량 이미지 표시 영역(3D로 자동으로 회전 할 예정)
                  CarWidget(carType: carType),
                  // 차량 선택 영역(차량을 선택하면 이미지 로딩 후 재 랜더링) => 이건 나중에 이쁜 UI 찾자
                  SelectWidget(onSelectionChanged: (selectedItem) {setState(() {carType = selectedItem;});},),
                  Height(height: 10,),
                  // 차량 번호 입력 영역(TextFeild)
                  CarNumberWidget(onChanged: (value){
                    carNumber = value;
                    print(carNumber);
                  },),
                  // Expanded(child: SizedBox()),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  ButtonWidget(
                    onPressed: () async {
                      setState(() {
                        _isUploading = true;
                      });

                      int carId = await registCar(context, CarData(carNumber: carNumber!, carType: carType!));

                      setState(() {
                        _isUploading = false;
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(carId: carId,)));
                    },)
                ],
              )
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
      _isUploading ? Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5), // 어두운 효과
          child: Center(child: CircularProgressIndicator()),
        ),
      ) : SizedBox(),
      ]
    );
  }
}
