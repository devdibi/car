import 'dart:async';

import 'package:car_project/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';


class LogoScreen extends StatefulWidget{
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>{

  @override
  void initState(){
    super.initState();

    // 설정한 시간동안 보여주고 다음 페이지로 이동, 다른 페이지의 로딩을 자연스럽게 하기 위해 추가함
    Timer(Duration(seconds:2), (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child:
        // 로고가 들어갈 페이지,
        Container(
          height: 300,
          width: 300,
          color: Colors.purpleAccent,
        )
      ),
    );
  }
}

