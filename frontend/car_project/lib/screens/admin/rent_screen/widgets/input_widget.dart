
import 'package:flutter/material.dart';

class RentInputWidget extends StatefulWidget{
  final ValueChanged<String> onChanged;

  RentInputWidget({
    Key? key,
    required this.onChanged,
  }): super(key: key);

  @override
  _RentInputWidgetState createState() => _RentInputWidgetState();
}

class _RentInputWidgetState extends State<RentInputWidget>{
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
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: _controller.text.isEmpty ? "고객의 이메일을 입력해주세요." : _controller.text,
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)), // 현재 적용이 안됨 넘어가자
          ),
          controller: _controller,
          onChanged: widget.onChanged,
        ));
  }
}