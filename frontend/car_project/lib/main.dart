
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/logo_screen/logo_screens.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: LogoScreen(),
    );
  }
}