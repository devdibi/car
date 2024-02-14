
import 'package:flutter/material.dart';

class MainSelect extends StatelessWidget{
  final String carNumber;
  final String date;
  final Widget next;

  const MainSelect({
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
        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(247, 247, 247, 100)),
        fixedSize: MaterialStateProperty.all<Size>(Size(300,300)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      child: Container(
        child:Column(
            children : [
              Expanded(
                child: Container(
                  child: ClipRect(child: Image.asset('assets/images/car/hyundai/avante/common (4).png', fit: BoxFit.fitWidth,),)
                ),
            ),
              Container(
                width: 400,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(carNumber, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),),
                    Text('등록일자 : $date', style: TextStyle(fontSize: 16, color: Colors.white),),
                  ],
                ),
              )
          ],
        ),
      ),
    );

  }
}
