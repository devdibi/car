//
// import 'dart:async';
//
// import 'package:car_project/assets/h2.dart';
// import 'package:car_project/screens/main/main_screen.dart';
// import 'package:car_project/temp_screen/result_screen.dart';
// import 'package:car_project/widgets/progress_ring.dart';
// import 'package:car_project/common_widgets/space_height.dart';
// import 'package:flutter/material.dart';
//
// class ProgressScreen extends StatefulWidget{
//   @override
//   _ProgressScreenState createState() => _ProgressScreenState();
// }
//
//
// class _ProgressScreenState extends State<ProgressScreen>{
//
//   @override
//   void initState(){
//     super.initState();
//
//     Timer(Duration(seconds:3), (){
//       Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Container(
//           width: 500,
//           height: 900,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               H2(str: "검사중입니다."),
//               H2(str: "잠시만 기다려주세요."),
//               Height(height: 30),
//               ContinuousProgressRing(
//                 radius: 100.0,
//                 color: Colors.red,
//               )
//             ],
//           )
//       ),
//     );
//   }
// }