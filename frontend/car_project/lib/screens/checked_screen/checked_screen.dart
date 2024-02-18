
import 'package:car_project/common_widgets/image_block.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CheckedScreen extends StatelessWidget{
  final String imagePath;
  final CameraDescription? camera;
  final int section;

  const CheckedScreen({
    Key? key,
    required this.imagePath,
    required this.camera,
    required this.section
  }) : super(key: key);

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
          child: Column(
            children: [
              Container(
                width: 400,
                height: 300,
                child: buildImage(imagePath),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  color: Colors.greenAccent,
                  child: Container(alignment: Alignment.center, height: 1000,width: 1000, color: Colors.white, child: Text("검사 결과 표시 영역"),),
                )
              ),
              Container(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(camera: camera, carId: 1,))),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
                      fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
                      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      elevation: MaterialStateProperty.all(2)
                  ),
                  child: Text("저장하기", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          )
      ),
    );
  }
}