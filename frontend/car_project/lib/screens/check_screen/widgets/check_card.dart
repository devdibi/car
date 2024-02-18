
import 'package:car_project/common_widgets/dummy_page.dart';
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

  CheckCard({
    Key? key,
    required this.part,
    required this.partNum,
    required this.camera,
    required this.status,
    required this.carType,
    required this.section
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 500,
      height: 300,
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
            child: Image.asset("assets/images/car/$carType/common ($partNum).png"),
          ),
          // info set
          Expanded(
          child: Container(
              child: Row(
                children: [
                  // info
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$part", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Text("crack_info")
                        ],
                      )
                    ),
                  ),
                  status == 0 ? Container(width: 50, alignment: Alignment.topRight, child: Icon(Icons.question_mark),) : status == 1 ? Container(width: 50, alignment: Alignment.topRight, child: Icon(Icons.check),) : Container(width: 50, alignment: Alignment.topRight, child: Icon(Icons.warning_amber),)
                ],
              ),
            ),
          ),
          // check button
          Container(
            child: TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: camera, section: section,)));
              },
              child: Text("검사하기", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}