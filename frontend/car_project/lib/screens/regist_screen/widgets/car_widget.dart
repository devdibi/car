
import 'package:flutter/material.dart';

class CarWidget extends StatelessWidget{
  String? carType;

  CarWidget({
    Key? key,
    required this.carType
  }): super(key: key);

  // 후에 가능하면 360도 회전 수행
  @override
  Widget build(BuildContext context){
    return Container(width: 500, height: 400, child: Image.asset("assets/images/car/$carType/common (4).png"));
  }
}