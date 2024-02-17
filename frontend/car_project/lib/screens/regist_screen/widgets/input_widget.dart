
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget{
  final TextEditingController _controller = TextEditingController();

  TextEditingController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context){
    return
      Container(
        width: 400,
        height: 70,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "차량 번호를 입력해주세요",
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)), // 현재 적용이 안됨 넘어가자
          ),
          controller: _controller,
        ));
  }
}