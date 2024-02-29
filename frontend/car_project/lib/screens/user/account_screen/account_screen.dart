import 'package:car_project/main.dart';
import 'package:car_project/screens/common/login_screen/login_screen.dart';
import 'package:car_project/screens/user/navigation/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget{
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{


  @override
  Widget build(BuildContext context){
    final provider = Provider.of<Setting>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text("회원정보", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Center(child: Container(height:200, width: 200,child: Icon(Icons.account_circle_sharp, size: 150),),),
            SizedBox(height: 50,),
            Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 0), child: Text("안녕하세요!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
            Container(padding: EdgeInsets.fromLTRB(30, 0, 30, 0), child: Text("${provider.user!.name}님", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),),
            SizedBox(height: 50,),
            Container(color: Colors.black, height: 1,),
            Container(height: 50, child:TextButton(onPressed: (){

            }, child: Row(children: [SizedBox(width: 30,), Text("회원정보 변경", style: TextStyle(color: Colors.black),),Expanded(child: SizedBox()), Icon(Icons.keyboard_arrow_right)],), style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),)), ),),),
            Container(color: Colors.black, height: 1,),
            Container(height: 50, child:TextButton(onPressed: (){
              provider.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }, child: Row(children: [SizedBox(width: 30,), Text("로그아웃", style: TextStyle(color: Colors.black),),Expanded(child: SizedBox()), Icon(Icons.keyboard_arrow_right)],), style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),)), ),),),
            Container(color: Colors.black, height: 1,),
          ],
        ),
      ),
      bottomNavigationBar: UserNavigationBar(),
    );
  }
}