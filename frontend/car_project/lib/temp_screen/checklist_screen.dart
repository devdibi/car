//
// import 'package:car_project/widgets/body_widget.dart';
// import 'package:car_project/widgets/car_check.dart';
// import 'package:flutter/material.dart';
//
// class CarCheckList extends StatefulWidget{
//   @override
//   _CarCheckListState createState() => _CarCheckListState();
// }
//
// class _CarCheckListState extends State<CarCheckList>{
//
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Grid(
//         child: ListView(
//           children: [
//             CarCheck(title: "전면", info: ["1개의 찌그러짐 존재"], checked: true),
//             CarCheck(title: "좌측", info: ["2개의 찌그러짐 존재"], checked: true),
//             CarCheck(title: "후면", info: ["3개의 찌그러짐 존재"], checked: false),
//             CarCheck(title: "우측", info: ["0개의 찌그러짐 존재"], checked: false),
//           ],
//         ),
//       )
//     );
//   }
// }