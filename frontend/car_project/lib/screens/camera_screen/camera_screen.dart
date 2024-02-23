
import 'package:car_project/screens/camera_screen/widgets/camera_widget.dart';
import 'package:car_project/screens/camera_screen/widgets/take_button.dart';
import 'package:car_project/screens/preview_screen/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget{
  final CameraDescription? camera; // camera description
  final int section;
  final int sectionId;
  final int carId;

  CameraScreen({
    Key? key,
    required this.camera,
    required this.section,
    required this.sectionId,
    required this.carId,
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: CameraWidget(camera: widget.camera, section: widget.section, sectionId: widget.sectionId ,carId: widget.carId),
    );
  }
}