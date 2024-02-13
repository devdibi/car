
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const LoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.greenAccent,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromARGB(88, 88, 88, 100)),
        fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Colors.white)
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
      ),
    );
  }
}

