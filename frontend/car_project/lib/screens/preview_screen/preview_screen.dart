import 'dart:io';
import 'package:car_project/common/height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/screens/camera_screen/camera_screen.dart';
import 'package:car_project/screens/checked_screen/checked_screen.dart';
import 'package:car_project/screens/preview_screen/api/classification.dart';
import 'package:car_project/screens/preview_screen/api/detection.dart';
import 'package:car_project/screens/preview_screen/api/upload.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget{
  @override
  _PreviewScreenState createState() => _PreviewScreenState();

  File? image;
  String? imagePath;
  final CameraDescription? camera;
  final int section;
  final int sectionId;
  final int carId;

  PreviewScreen({
    Key? key,
    required this.image,
    required this.imagePath,
    required this.camera,
    required this.section,
    required this.sectionId,
    required this.carId
  }) : super(key: key);

}

class _PreviewScreenState extends State<PreviewScreen>{
  bool _isUploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(widget.imagePath!,),
                  // child: AspectRatio(
                  //     aspectRatio: 4 / 3, // 가로 세로 비율을 여기에 설정합니다.
                  //     child: kIsWeb ? Image.network(widget.imagePath!, fit: BoxFit.fitWidth,) : Image.network(widget.imagePath!, fit: BoxFit.fitWidth,)
                  //   ),
                ),
                Height(height: 100),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20,),
                    Button(() {
                      widget.imagePath = null;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: widget.camera, section: widget.section, sectionId: widget.sectionId, carId: widget.carId)));
                    }, "다시 촬영"),
                    SizedBox(width: 20,),
                    // 버튼 클릭과 동시에 버킷에 저장
                    Button(() async {
                      setState(() {_isUploading = true;});

                      // detection
                      await detection(widget.sectionId, widget.section);

                      // classification
                      await classification(widget.sectionId, widget.section);

                      setState(() {_isUploading = false;});

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckedScreen(camera: widget.camera, sectionId: widget.sectionId, section : widget.section, carId: widget.carId)));
                    }, "검사하기"),
                    SizedBox(width: 20,),
                  ],
                )
              ],
            )
          ),
          _isUploading ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // 어두운 효과
              child: Center(child: CircularProgressIndicator()),
            ),
          ) : SizedBox(),
        ],
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

  String filePath(BuildContext context){
    final provider = Provider.of<Setting>(context, listen: false);
    var userId = provider.user!.getId();

    String path = 'image/$userId/${widget.carId}/${widget.section}.jpg';

    return path;
  }

  Future<void> _image() async{
    String imagePath = await selectFile(widget.image!, widget.sectionId, widget.section);
    setState(() {
      widget.imagePath = imagePath;
    });
  }
}