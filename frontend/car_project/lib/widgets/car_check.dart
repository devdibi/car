//
// import 'package:car_project/assets/h2.dart';
// import 'package:car_project/temp_screen/progress_screen.dart';
// import 'package:car_project/screens/save_screen.dart';
// import 'package:car_project/screens/login/widgets/login_button.dart';
// import 'package:car_project/temp_screen/result_screen.dart';
// import 'package:car_project/common_widgets/space_height.dart';
// import 'package:flutter/material.dart';
//
// class CarCheck extends StatelessWidget{
//   final String title;
//   // final Image image;
//   final List<String> info;
//   final bool checked;
//
//   const CarCheck({
//     Key? key,
//     required this.title,
//     // this.image = Image(image: ImageProvider(""),),
//     required this.info,
//     required this.checked
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context){
//     return Container(
//       child: Column(
//         children: [
//           Container(
//             child: H2(str: title),
//             alignment: Alignment.centerLeft,
//             width: 300
//           ),
//           // Image(),
//           if(!checked)
//             NextButton(text: "점검하기", onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressScreen()));
//             }),
//           if(checked)
//             Container(
//               padding: EdgeInsets.all(10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(width: 20,),
//                   Container(
//                     width: 150,
//                     height: 100,
//                     child: Text(info[0]),
//                   )
//                 ],
//               ),
//             ),
//           if(checked)
//             NextButton(text: "재 점검하기", onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => SaveScreen()));
//             }),
//           Height(height: 30)
//         ],
//       ),
//     );
//   }
// }