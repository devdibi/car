import 'dart:convert';
import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/login_screen/widgets/input_text.dart';
import 'package:car_project/screens/login_screen/widgets/login_button.dart';
import 'package:car_project/screens/login_screen/widgets/logo.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  String? email;
  String? password;
  bool wrongAccount = false;

  @override
  void initState(){super.initState();}

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(
            children: [
              Height(height: 100),
              Container(
                width: MediaQuery.of(context).size.width,
                child: const Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Logo(logo: "Welcome,"), Text("Sign in to continue!"),]),
              ),
              Height(height: 100,),
              Container(
                height: 200,
                width: 200,
                child: Image.asset("assets/images/login.png"),
              ),
              Height(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(150, 150, 105, 100), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    Container(
                      child: Image.asset("assets/images/mail.png", width: 35, height: 35),
                    ),
                    SizedBox(width: 7,),
                    Expanded(child: LoginInputText(hint: "Enter email id", secure: false, onChanged: (value) => email = value,),)
                  ],
                ),
              ),
              Height(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(150, 150, 105, 100), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(width: 5,),
                    Image.asset("assets/images/lock.png", width: 35, height: 30,),
                    SizedBox(width: 10,),
                    Expanded(child: LoginInputText(hint: "Enter password", secure: true, onChanged: (value) => password = value,),)
                  ],
                ),
              ),
              Height(height: 20,),
              LoginButton(text: "로그인",
                  onPressed: (){fetchData(context);}),
              if(wrongAccount) Height(height: 20,),
              if(wrongAccount) Container(child: Text("입력된 정보가 올바르지 않습니다.", style: TextStyle(color: Colors.red),),),
          ],
        )
      )
    );
  }

  Future<void> fetchData(BuildContext context) async{
    final setting = Provider.of<Setting>(context, listen: false);

    try{
      var url = Uri.parse('http://127.0.0.1:5000/user/login');

      var request = {'email': email, 'password' : password};

      var response = await http.post(
        url, body: json.encode(request), headers: {'Content-type': 'application/json'},
      );

      var responseData = json.decode(response.body);

      if(responseData['data'] != null){
        // provider에 유저 정보 추가
        setting.setUser(UserData(id: responseData['data']['id'], email: responseData['data']['email'], name: responseData['data']['name']));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }else{
        setState(() => wrongAccount = true);
      }
        // size 생성

    }catch(e){
      print(e);
      setState(() => wrongAccount = true);
    }
  }
}