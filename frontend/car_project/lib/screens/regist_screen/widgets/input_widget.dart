
import 'package:flutter/material.dart';

class CarNumberWidget extends StatefulWidget{
  final ValueChanged<String> onChanged;

  CarNumberWidget({
    Key? key,
    required this.onChanged,
  }): super(key: key);

  @override
  _CarNumberWidgetState createState() => _CarNumberWidgetState();
}

class _CarNumberWidgetState extends State<CarNumberWidget>{
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextEditingController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context){
    return Container(
        width: 400,
        height: 70,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: _controller.text.isEmpty ? "차량 번호를 입력해주세요" : _controller.text,
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)), // 현재 적용이 안됨 넘어가자
          ),
          controller: _controller,
          onChanged: widget.onChanged,
        ));
  }
}