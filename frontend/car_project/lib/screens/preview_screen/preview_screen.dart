
import 'dart:io';

import 'package:car_project/common_widgets/image_block.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/checked_screen/checked_screen.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PreviewScreen extends StatelessWidget{
  final String imagePath;
  final CameraDescription? camera;
  final int section;

  const PreviewScreen({
    Key? key,
    required this.imagePath,
    required this.camera,
    required this.section
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImage(imagePath),
            Height(height: 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(() => Navigator.pop(context), "다시 촬영"),
                SizedBox(width: 20,),
                Button(() => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckedScreen(imagePath: imagePath, camera: camera, section : section))), "검사하기"),
              ],
            )
          ],
        )
      ),
    );
  }

  Widget Button(VoidCallback function, String text){
    return Expanded(
        child: ElevatedButton(
        onPressed: function,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
            side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
            fixedSize: MaterialStateProperty.all(Size.fromHeight(60)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            elevation: MaterialStateProperty.all(2)
          ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
      )
    );
  }
}