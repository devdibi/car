
import 'package:car_project/common_widgets/dummy_page.dart';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/main_screen/widgets/main_card.dart';
import 'package:car_project/screens/main_screen/widgets/summary_info.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  List<Widget> list = [];

  @override
  void initState(){
    // Backend에서 호출해와야 함
    list.addAll(
        [
        Height(height: 30,),
        SummaryInfo(user: "유저", len: 3,),
        Height(height: 20),
        MainCard(carNumber: "carNum", date: "2024.02.03", next: DummyPage(),)
        ]);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
            children: list,
          ),
          Positioned(
            right: 30,
            bottom: 50,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage()));
            }, child: Container(height: 80, width: 30, padding:EdgeInsets.zero, child: Center(child: Text("+", style: TextStyle(fontSize: 50, color: Colors.white),),),), style: ButtonStyle(elevation: MaterialStateProperty.all(5),backgroundColor: MaterialStateProperty.all(Colors.purpleAccent)),),
          )
        ],
      )
    );
  }
}