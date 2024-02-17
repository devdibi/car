
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CheckedScreen extends StatelessWidget{
  final String imagePath;
  final CameraDescription? camera;

  const CheckedScreen({
    Key? key,
    required this.imagePath,
    required this.camera
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          children: [
            Image.network(imagePath),
            Height(height: 500),
            Container(
              width: 400,
              height: 60,
              child: ElevatedButton(
                // onPressed: () => Navigator.popUntil(context, (route) {return route.settings.name == '/check';}),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(camera: camera,))),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
                    fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
                    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                ),
                child: Text("차량 등록하기", style: TextStyle(color: Colors.white, fontSize: 16),),
              ),
            )
          ],
        )
      ),
    );
  }
}