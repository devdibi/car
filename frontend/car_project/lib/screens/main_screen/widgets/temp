
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget{
  final String carNumber;
  final String date;
  final Widget next;

  const MainCard({
    Key? key,
    required this.carNumber,
    required this.date,
    required this.next,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => next));
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
          fixedSize: MaterialStateProperty.all(Size.fromWidth(300)),
          elevation: MaterialStateProperty.all(5),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          padding: MaterialStateProperty.all(EdgeInsets.zero)
      ),
      child: Container(
        width: 400,
        height: 150,
        child: Column(
          children: [
            ListTile(
                title: Text(carNumber),
                titleTextStyle: TextStyle(
                    fontSize: 20, color: Colors.black,)
            ),
            ListBody(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Text('등록일자 : $date', style: TextStyle(color: Colors.black),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
