

import 'dart:io';

import 'package:car_project/screens/admin/preview_screen/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraWidget extends StatefulWidget{
  final CameraController camera; // camera description
  final int section;
  final int sectionId;
  final int carId;

  CameraWidget({
    Key? key,
    required this.camera,
    required this.section,
    required this.sectionId,
    required this.carId
  }): super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();

}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller; // camera controller
  late Future<void> _initializeControllerFuture; // init controller

  @override
  void initState() {
    super.initState();
    _controller = widget.camera;
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 상태가 완료인 경우
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 500,
                height: 300,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.75,
                child: AspectRatio(
                  aspectRatio: 3 / 4, // 가로 세로 비율을 여기에 설정합니다.
                  child: CameraPreview(_controller),
                ),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(50, 50)),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                child: Icon(Icons.camera_alt),
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    XFile image = await _controller.takePicture(); // 촬영 이미지 저장
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
                    ); // 미리보기 페이지 이동
                  } catch (e) {
                    print("사진 촬영 오류 : $e"); // 에러 메시지 출력
                  }
                },
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          ); // 로딩 화면 표시
        }
      },
    );
  }
}