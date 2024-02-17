
import 'package:car_project/screens/camera_screen/widgets/camera_widget.dart';
import 'package:car_project/screens/camera_screen/widgets/take_button.dart';
import 'package:car_project/screens/preview_screen/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget{
  final CameraDescription? camera; // camera description

  CameraScreen({
    Key? key,
    required this.camera
  }): super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();

}

class _CameraScreenState extends State<CameraScreen>{
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Transform.rotate(
        // angle: 90 * 3.141592653589793 / 180,
        angle: 0,
        child: CameraWidget(camera: widget.camera,),
      )
    );
  }
}