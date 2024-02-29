import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/screens/admin/camera_screen/camera_screen.dart';
import 'package:car_project/screens/admin/checked_screen/checked_screen.dart';
import 'package:car_project/screens/admin/preview_screen/api/classification.dart';
import 'package:car_project/screens/admin/preview_screen/api/detection.dart';
import 'package:car_project/screens/admin/preview_screen/api/upload.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  @override
  _PreviewScreenState createState() => _PreviewScreenState();

  File? image;
  String? imagePath;
  final int section;
  final int sectionId;
  final int carId;

  PreviewScreen({
    Key? key,
    required this.image,
    required this.section,
    required this.sectionId,
    required this.carId,
  }) : super(key: key);
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _image();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.imagePath == null
                    ? Center(child: CircularProgressIndicator())
                    : CachedNetworkImage(
                  imageUrl: widget.imagePath!,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                ),
                Height(height: 200),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Button(() {
                      widget.imagePath = null;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraScreen(
                            section: widget.section,
                            sectionId: widget.sectionId,
                            carId: widget.carId,
                          ),
                        ),
                      );
                    }, "다시 촬영"),
                    SizedBox(width: 20),
                    Button(() async {
                      setState(() {
                        _isUploading = true;
                      });

                      // detection
                      await detection(widget.sectionId, widget.section);

                      // classification
                      await classification(widget.sectionId, widget.section);

                      setState(() {
                        _isUploading = false;
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckedScreen(
                            sectionId: widget.sectionId,
                            section: widget.section,
                            carId: widget.carId,
                          ),
                        ),
                      );
                    }, "검사하기"),
                    SizedBox(width: 20),
                  ],
                )
              ],
            ),
          ),
          _isUploading
              ? Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget Button(VoidCallback function, String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: function,
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
          side: MaterialStateProperty.all<BorderSide>(
              const BorderSide(color: Colors.white)),
          fixedSize: MaterialStateProperty.all(Size.fromHeight(60)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15))),
          elevation: MaterialStateProperty.all(2),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _image() async {
    String imagePath = await selectFile(widget.image!, widget.sectionId, widget.section);
    setState(() {
      widget.imagePath = imagePath;
    });
  }
}
