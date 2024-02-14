
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckScreen extends StatefulWidget{
  @override
  _CheckScreenState createState() => _CheckScreenState();

}

class _CheckScreenState extends State<CheckScreen>{
  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('점검 목록', style: TextStyle(fontSize: 24),),
        toolbarHeight: 50,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);},),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child:
          // fetchData를 이용해서 데이터 로딩 후 랜더링
          Center(child: Container(width: 500, height: 900, color: Colors.greenAccent,),),
      ),
    );
  }

  // Future<List<Widget>> fetchData(){
  //
  //   // Text
  //   // Image
  //   // Info
  // }


}