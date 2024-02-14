
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
            backgroundColor: MaterialStateProperty.all(Color.fromRGBO(150, 150, 150, 100)),
            fixedSize: MaterialStateProperty.all<Size>(Size(50,100)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          ),
          child: Container(
            child: Row(
              children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))), child: Image.asset('assets/images/car/hyundai/avante/common (4).png', fit: BoxFit.fitWidth,),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(carNumber, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        Text('등록일자 : $date', style: TextStyle(fontSize: 12, color: Colors.white),),
                      ],
                    ),
                  ),)
              ],
            ),
          ),
      );

  }
}
