
import 'package:car_project/screens/logo_screen/logo_screens.dart';
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