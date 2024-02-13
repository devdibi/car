
import 'package:flutter/material.dart';

class LoginInputText extends StatelessWidget{
  final TextEditingController _controller = TextEditingController();
  final String hint;
  final bool secure;
  final ValueChanged<String> onChanged;

  LoginInputText({
    Key? key,
    required this.hint,
    required this.secure,
    required this.onChanged
}): super(key: key);


  TextEditingController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 200,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        obscureText: secure,
        onChanged:  onChanged
      ),
    ) ;

  }

}