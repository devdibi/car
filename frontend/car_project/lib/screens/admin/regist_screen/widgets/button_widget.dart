import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget{
  final VoidCallback onPressed;

  ButtonWidget({
    Key? key,
    required this.onPressed,
  }): super(key: key);


  @override
  Widget build(BuildContext context){
    return Container(
      width: 400,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
            fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
            side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
        ),
        child: Text("차량 등록하기", style: TextStyle(color: Colors.white, fontSize: 16),),
      ),
    );
  }

  // POST 요청
}