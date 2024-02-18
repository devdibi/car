
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/preview_screen/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget{
  final CameraDescription? camera; // camera description
  final int section;

  CameraWidget({
    Key? key,
    required this.camera,
    required this.section
  }): super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();

}

class _CameraWidgetState extends State<CameraWidget>{
  late CameraController _controller; // camera controller
  late Future<void> _initializeControllerFuture; // init controller

  @override
  void initState(){
    super.initState();

    _controller = CameraController(
        widget.camera!, // camera widget
        ResolutionPreset.medium // start resolution
    );

    _initializeControllerFuture = _controller.initialize(); // camre init
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                // 상태가 완료인 경우
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CameraPreview(_controller), // 이미지 미리보기 제공
                      SizedBox(height: 50,),
                      ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(50,50)),
                              padding: MaterialStateProperty.all(EdgeInsets.zero)
                          ),
                          child: Icon(Icons.camera_alt),
                          onPressed: () async {
                            try{

                              await _initializeControllerFuture;

                              final image = await _controller.takePicture(); // 촬영 이미지 저장

                              Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(imagePath: image.path, camera: widget.camera, section: widget.section))); // 미리보기 페이지 이동
                            }catch (e){
                              print("사진 촬영 오류 : $e"); // 에러 메시지 출력
                            }
                          }
                      ),
                    ],
                  );
              }else{
                return Center(child: CircularProgressIndicator(),); // 로딩 화면 표시
              }
            },
      );
  }
}