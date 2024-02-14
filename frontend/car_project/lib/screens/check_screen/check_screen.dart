
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
        title: Text('점검 목록', style: TextStyle(fontSize: 36),),
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 버튼을 눌렀을 때 동작할 코드를 작성합니다.
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.black,
            thickness: 3,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(
          children: [
            Container(

            )
          ],
        )
      ),
    );
  }
}