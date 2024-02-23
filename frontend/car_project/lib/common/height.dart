
import 'package:flutter/material.dart';

class Height extends StatelessWidget{
  final double height;

  const Height({
    Key? key,
    required this.height
  }):super(key: key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height
    );
  }
}