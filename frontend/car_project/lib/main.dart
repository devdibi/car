

import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/camera_screen/camera_screen.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/login_screen/login_screen.dart';
import 'package:car_project/screens/logo_screen/logo_screens.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:car_project/screens/regist_screen/regist_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // MedeaQuery 사용을 위한 초기화
  final cameras = await availableCameras(); // 사용가능한 카메라 확인

  CameraDescription? firstCamera;

  if(cameras.isNotEmpty){
    firstCamera = cameras[0];
  }else{
    print("사용가능한 카메라가 없습니다.");
  }

  runApp(MyApp(camera: firstCamera,));
}

class MyApp extends StatelessWidget{
  final CameraDescription? camera;

  MyApp({
    Key? key,
    required this.camera
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => Setting(),
      child: MaterialApp(
        title: "차바오",
        home: LogoScreen(camera: camera),
      )
    );
  }
}

class Setting with ChangeNotifier{
  UserData? _user;

  UserData? get user => _user;

  void setUser(UserData user){
    _user = user;
    notifyListeners();
  }
}