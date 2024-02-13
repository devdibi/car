
import 'package:flutter/material.dart';

class Logo extends StatelessWidget{
  final String logo;

  const Logo({
    Key? key,
    required this.logo
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Text(
      logo,
      style: const TextStyle(fontSize: 36, fontFamily: "AppleGothic", fontWeight: FontWeight.bold),
    );
  }
}