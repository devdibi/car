
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/checked_screen/checked_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PreviewScreen extends StatelessWidget{
  final String imagePath;
  final CameraDescription? camera;

  const PreviewScreen({
    Key? key,
    required this.imagePath,
    required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imagePath),
            Height(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("left")),
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckedScreen(imagePath: imagePath, camera: camera,))), child: Text("right"))
              ],
            )
          ],
        )
      ),
    );
  }

  // Future<String> uploadImage(File imageFile) async {
  //   try{
  //     String fileName = 'image.png'; // 파일명 지정해야함
  //
  //     Reference
  //
  //   }
  // }
}