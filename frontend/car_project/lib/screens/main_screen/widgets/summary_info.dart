
import 'package:flutter/material.dart';

class SummaryInfo extends StatelessWidget{
  final String user;
  final int len;

  const SummaryInfo({
    Key? key,
    required this.user,
    required this.len,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Text("$user님의 차량이 $len대 있습니다.",
          style: const TextStyle(
              fontSize: 20,
              fontFamily: "AppleGothic",
              fontWeight: FontWeight.bold
          )),
    );
  }
}