import 'dart:io';
import 'dart:math';

import 'package:car_project/screens/admin/check_screen/check_screen.dart';
import 'package:car_project/screens/admin/preview_screen/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  final int section;
  final int sectionId;
  final int carId;

  CameraScreen({
    Key? key,
    required this.section,
    required this.sectionId,
    required this.carId,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    // 사용 가능한 카메라 목록 가져오기
    availableCameras().then((cameras) {
      // 첫번째 카메라 선택
      final firstCamera = cameras.first;

      // controller 초기화
      _controller = CameraController(firstCamera, ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("카메라 로딩 중"),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            ClipRRect(
              child: SizedOverflowBox(
                size: const Size(500, 600),
                alignment: Alignment.center,
                child: CameraPreview(_controller),
              ),
            ),
            SizedBox(height: 50,),
            Container(
              width: MediaQuery.of(context).size.width,
             height: 100,
             child: Stack(
               children: [
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.45,
                    child: Transform.rotate(
                    angle: 90 * (pi / 180),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(70, 70)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        try {
                          XFile image = await _controller.takePicture();
                          File file = File(image.path);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewScreen(
                                image: file,
                                // imagePath: image.path,
                                section: widget.section,
                                sectionId: widget.sectionId,
                                carId: widget.carId,
                              ),
                            ),
                          );
                        } catch (e) {
                          print("사진 촬영 오류 : $e");
                        }
                      },
                    ),
                  ),
                ),

               Positioned(
                 right: MediaQuery.of(context).size.width * 0.15,
                 top: 5,
                 child:
                 Transform.rotate(
                    angle: 90 * (pi / 180),
                    child: TextButton(child: Text("취소", style: TextStyle(fontSize: 20),), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(carId: widget.carId)))),
                  )
               ),
               ],
             ),
            )
          ],
        ),
      ),
    );
  }
}
