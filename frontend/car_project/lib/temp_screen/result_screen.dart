//
// import 'package:flutter/material.dart';
//
// class ResultScreen extends StatelessWidget{
//   final String date;
//
//   const ResultScreen({
//     required this.date
//   });
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("결과입니다."),
//             Text(date),
//             BackButton(
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }