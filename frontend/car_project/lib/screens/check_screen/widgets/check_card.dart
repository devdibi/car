

import 'package:car_project/screens/camera_screen/camera_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CheckCard extends StatelessWidget{
  final CameraDescription? camera;
  final String part;
  final int partNum;
  final int status;
  final String carType;
  final int section;
  final int sectionId;
  final int carId;
  // final List<Widget> cracks;

  CheckCard({
    Key? key,
    required this.part,
    required this.partNum,
    required this.camera,
    required this.status,
    required this.carType,
    required this.section,
    required this.sectionId,
    required this.carId,
    // required this.cracks
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 500,
      height: 350,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(200, 200, 200, 100),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          // image set
          Container(
            height: 150,
            child: Image.asset("assets/images/car/$carType/common ($partNum).png",),
          ),
          Container(height: 1, color: Colors.black,),
          // info set
          Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: [
                  // info
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$part", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          Text("3개의 손상이 있습니다.")
                          // cracks != null && cracks.isNotEmpty ? Column(children: cracks) : Text("손상이 없습니다.")
                        ],
                      )
                    ),
                  ),
                  status == 0 ? Container() : status == 1 ? Container(width: 50, alignment: Alignment.topRight, child: Icon(Icons.check, color: Colors.green,),) : Container(width: 50, alignment: Alignment.topRight, child: Icon(Icons.warning_amber, color: Colors.red),)
                ],
              ),
            ),
          ),
          // check button
          Container(
            height: 40,
            width: 150,
            child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera, section: section, sectionId: sectionId ,carId: carId,)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 30, alignment: Alignment.center,child: Text( status == 0 ? "검사하기" : "다시 검사하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
                    Container(height: 30, alignment: Alignment.topCenter,child: Icon(Icons.touch_app, color: Colors.white,),)
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

}

// ElevatedButton(
// style: ButtonStyle(
// backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 20, 230, 100)),
// side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
// fixedSize: MaterialStateProperty.all(Size.fromHeight(60)),
// shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
// elevation: MaterialStateProperty.all(2)
// ),
// onPressed: (){
// Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera, section: section, carId: carId,)));
// },
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(height: 30, alignment: Alignment.center,child: Text( status == 0 ? "검사하기" : "다시 검사하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),),
// Container(height: 30, alignment: Alignment.topCenter,child: Icon(Icons.touch_app, color: Colors.white,),)
// ],
// )
// ),