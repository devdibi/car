import 'package:car_project/screens/user/board_screen/board_screen.dart';
import 'package:flutter/material.dart';

Widget body(BuildContext context, bool _hasCar, String carType, int pictureNum, String carNumber, String date, int carId, DateTime rentedAt, DateTime returnedAt){
  return Container(
    padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,

    child: _hasCar ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 200,),
        Hero(
          tag: 'carImage',
          child: Container(
            child: Image.asset(
              'assets/images/car/$carType/common ($pictureNum).png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Expanded(child: Container()),
        Row(children: [
          Column(
            children: [
              Text(carNumber, style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
              // Text(date, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Expanded(child: Container()),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => BoardScreen(carId: carId)));
            },
            child: Row(
              children: [
                Text("정보 보기", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                Icon(Icons.arrow_right_alt, size: 30, color: Colors.black,)
              ],
            ),
          )
        ],
        ),
        Text("대여기간"),
        Text("${rentedAt.year}년 ${rentedAt.month}월 ${rentedAt.day} ~ ${returnedAt.year}년 ${returnedAt.month}월 ${returnedAt.day}일")
      ],
    ) : Center(child: Text('현재 대여중인 차량이 없습니다.')),
  );
}