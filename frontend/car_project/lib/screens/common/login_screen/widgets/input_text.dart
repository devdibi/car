
import 'package:flutter/material.dart';
class LoginInputText extends StatefulWidget{
  final ValueChanged<String> onChanged;
  final String hint;
  final bool secure;


  LoginInputText({
    Key? key,
    required this.hint,
    required this.secure,
    required this.onChanged
  }): super(key: key);

  @override
  _LoginInputTextState createState() => _LoginInputTextState();
}


class _LoginInputTextState extends State<LoginInputText>{
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
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: widget.hint, border: InputBorder.none),
        obscureText: widget.secure,
        onChanged:  widget.onChanged
      ),
    ) ;

  }

}