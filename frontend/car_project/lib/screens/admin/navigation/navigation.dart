import 'package:car_project/main.dart';
import 'package:car_project/screens/admin/account_screen/account_screen.dart';
import 'package:car_project/screens/admin/main_screen/admin_main_screen.dart';
import 'package:car_project/screens/admin/rent_list_screen/rent_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminNavigationBar extends StatefulWidget{
  @override
  _AdminNavigationBarState createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar>{


  @override
  Widget build(BuildContext context){
    final provider = Provider.of<Setting>(context, listen: false);

    return BottomNavigationBar(
        currentIndex: provider.currentIndex!,
        onTap: (index){selectIndex(context, index);},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "차량목록"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "렌트중"),
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
          context, MaterialPageRoute(builder: (context) => AdminMainScreen()));
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RentListScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
    }
  }
}