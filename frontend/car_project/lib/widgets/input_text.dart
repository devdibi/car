//
// import 'package:flutter/material.dart';
//
// class InputText extends StatelessWidget{
//   final TextEditingController _controller = TextEditingController();
//   final String hint;
//   final bool type;
//   final ValueChanged<String> onChanged;
//
//   InputText({
//     Key? key,
//     required this.hint,
//     required this.type,
//     required this.onChanged
// }): super(key: key);
//
//
//   TextEditingController getController() {
//     return _controller;
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return SizedBox(
//       width: 300,
//       child: TextField(
//         controller: _controller,
//         decoration: InputDecoration(hintText: hint),
//         obscureText: type,
//         onChanged:  onChanged
//       ),
//     ) ;
//
//   }
//
// }