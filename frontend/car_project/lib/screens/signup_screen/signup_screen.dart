
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/screens/login_screen/login_screen.dart';
import 'package:car_project/screens/login_screen/widgets/input_text.dart';
import 'package:car_project/screens/signup_screen/widgets/admin_select.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget{

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  String email = "";
  String password = "";
  String name = "";
  int? role = -1;
  bool _signup = false;
  bool _wrong = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height*0.1,
                left: MediaQuery.of(context).size.width*0.05,
                child : Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    width: MediaQuery.of(context).size.width*0.9,
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // 각종 모서리 둥글기
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // 그림자 색상과 투명도 설정
                          spreadRadius: 3, // 그림자 전체의 퍼짐 정도 설정
                          blurRadius: 1, // 그림자의 흐릿함 정도 설정
                          offset: Offset(0, 3), // 그림자의 위치 설정 (수평, 수직)
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("회원가입", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                          SizedBox(height: 40,),
                          Container(
                              width: 300,
                              height: 100,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  LoginInputText(hint: "이메일을 입력해주세요.", secure: false, onChanged: (value) => email = value),
                                  Container(height: 1, width: 250, color: Colors.grey,)
                                ],
                              )
                          ),
                          Container(
                              width: 300,
                              height: 100,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  LoginInputText(hint: "비밀번호를 입력해주세요.", secure: true, onChanged: (value) => password = value),
                                  Container(height: 1, width: 250, color: Colors.grey,)
                                ],
                              )
                          ),
                          Container(
                              width: 300,
                              height: 100,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  LoginInputText(hint: "이름을 입력해주세요.", secure: false, onChanged: (value) => name = value),
                                  Container(height: 1, width: 250, color: Colors.grey,)
                                ],
                              )
                          ),
                          Container(
                              width: 300,
                              height: 100,
                              alignment: Alignment.center,
                              child: AdminSelectWidget(onSelectionChanged: (select) {setState(() {role = select;});},)
                          ),
                          SizedBox(height: 70,),
                          Container(
                              width: 250,
                              child: ElevatedButton(onPressed: (){
                                setState(() {
                                  _signup = true;
                                });

                                signup();

                              }, child: Text("회원가입", style: TextStyle(color: Colors.white),), style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
                                  fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 60)),
                                  side: MaterialStateProperty.all<BorderSide>(
                                      const BorderSide(color: Colors.white)
                                  ),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                              ),)
                          ),
                          if(_wrong) Text("잘못된 입력입니다.", style: TextStyle(color: Colors.red),)
                        ],
                      ),
                    )
                )
            ),
            if(_signup) Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // 어두운 효과
                child: Center(child: CircularProgressIndicator()),
              ),
            )],
        )
    );
  }

  Future<void> signup() async {
    try{
      var url = Uri.parse("${URI()}/user/register");

      Map<String, dynamic> body = {
        'email' : email,
        'password' : password,
        'name' : name,
        'role' : role
      };

      var response = await http.post(
          url, body: json.encode(body), headers: {'Content-type': 'application/json'}
      );

      if(json.decode(response.body)['code'] == 200){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }else{
        setState(() {
          _signup = false;
          _wrong = true;
        });
      }
      print(body);
    }catch(e){
      print(e);
    }
  }
}