
import 'dart:convert';
import 'dart:io';

import 'package:car_project/common_widgets/space_height.dart';
import 'package:car_project/screens/login_screen/widgets/input_text.dart';
import 'package:car_project/screens/login_screen/widgets/login_button.dart';
import 'package:car_project/screens/login_screen/widgets/logo.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  String? email;
  String? password;
  bool wrongAccount = false;

  @override
  void initState(){
  }

  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(100, 50, 100, 20),
          child: Column(
            children: [
              Height(height: 100),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Logo(logo: "Welcome,"),
                      Text("Sign in to continue!"),
                    ]),
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
                  onPressed: (){
                    /* backend 서버 확인 */
                    // Get 요청
                    // true일 경우 유저 정보를 저장하고 Provider에 저장한다

                    // false일 경우 Button 사이에 에러 메시지 출력.
                    // Provider 설정
                    setState(() {
                      wrongAccount = true;
                    });

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                  },),
              if(wrongAccount) Height(height: 20,),
              if(wrongAccount) Container(child: Text("입력된 정보가 올바르지 않습니다.", style: TextStyle(color: Colors.red),),),
          ],
        )
      )
    );
  }
  // Future<void> fetchData(String email, String password) async{
  //   try{
  //     var url = Uri.parse('https://127.0.0.1:5000/login');
  //
  //     var data = {
  //       'email': email,
  //       'password' : password
  //     };
  //
  //     var response = await http.post(
  //       url, body: json.encode(data), headers: {'Content-type': 'application-json'},
  //     );
  //
  //     if(response.statusCode == 200){
  //       var responseData = json.decode(response.body);
  //       setState(() {
  //         //
  //         userData.id = responseData['id'];
  //         userData.email = email;
  //         userData.name = responseData['name'];
  //       });
  //     }
  //   }
  // }
}