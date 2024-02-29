import 'package:car_project/main.dart';
import 'package:car_project/screens/user/account_screen/account_screen.dart';
import 'package:car_project/screens/user/list_screen/list_screen.dart';
import 'package:car_project/screens/user/main_screen/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNavigationBar extends StatefulWidget{
  @override
  _UserNavigationBarState createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<UserNavigationBar>{


  @override
  Widget build(BuildContext context){
    final provider = Provider.of<Setting>(context, listen: false);

    return BottomNavigationBar(
        currentIndex: provider.currentIndex!,
        onTap: (index){selectIndex(context, index);},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "차고"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "렌트기록"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "회원정보")
        ]);
  }

  void selectIndex(BuildContext context, int index) {
    final provider = Provider.of<Setting>(context, listen: false);

    setState(() {
      provider.setIndex(index);
    });

    print(provider.currentIndex);

    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserMainScreen()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
    }
  }
}