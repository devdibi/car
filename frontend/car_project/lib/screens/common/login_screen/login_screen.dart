import 'dart:convert';
import 'package:car_project/common/url.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/main.dart';
import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/admin/main_screen/admin_main_screen.dart';
import 'package:car_project/screens/common/login_screen/widgets/input_text.dart';
import 'package:car_project/screens/common/login_screen/widgets/login_button.dart';
import 'package:car_project/screens/common/login_screen/widgets/logo.dart';
import 'package:car_project/screens/common/signup_screen/signup_screen.dart';
import 'package:car_project/screens/user/main_screen/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget{

  LoginScreen({
    Key? key,
  }): super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  String? email;
  String? password;
  bool wrongAccount = false;
  bool _process = false;

  @override
  void initState(){super.initState();}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:
      Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child:Container(
                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.1, 50, MediaQuery.of(context).size.width*0.1, 0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Logo(logo: "Welcome,"),
                              Text("Sign in to continue!"),
                            ]
                        ),
                      ), // 상단 환영 메시지
                      Height(height: MediaQuery.of(context).size.height * 0.12,),
                      SizedBox(height: 250, width: 200, child: Image.asset("assets/images/chabao.png"),),
                      Height(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(150, 150, 105, 100), width: 2.0),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const SizedBox(width: 5,),
                            Container(
                                width: 35,
                                height: 35,
                                // child: Image.asset("assets/images/mail.png", width: 35, height: 35),
                                child: Icon(Icons.mail_outline, color: Colors.grey)
                            ),
                            const SizedBox(width: 7,),
                            Expanded(child: LoginInputText(hint: "Enter email id", secure: false, onChanged: (value) => email = value,),)
                          ],
                        ),
                      ),
                      const Height(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromARGB(150, 150, 105, 100), width: 2.0),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 35,
                              child: Icon(Icons.lock_outline, color: Colors.grey),
                            ),
                            Expanded(child: LoginInputText(hint: "Enter password", secure: true, onChanged: (value) => password = value,),)
                          ],
                        ),
                      ),
                      const Height(height: 20,),
                      LoginButton(text: "로그인",
                          onPressed: () async {
                            // login Circular
                            setState(() {_process = true;});

                            await fetchData(context);

                            setState(() {_process = false;});
                          }),
                      TextButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));},
                          child: Text("아직 회원이 아니신가요?")),
                      if(wrongAccount) const Height(height: 20,),
                      if(wrongAccount) Container(child: const Text("입력된 정보가 올바르지 않습니다.", style: TextStyle(color: Colors.red),),),

                    ],
                  )
              ),
            ),
          ),
          if(_process) Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // 어두운 효과
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> fetchData(BuildContext context) async{
    final setting = Provider.of<Setting>(context, listen: false);

    try{

      var url = Uri.parse('${URI()}/user/login');

      var request = {'email': email, 'password' : password};

      var response = await http.post(
        url, body: json.encode(request), headers: {'Content-type': 'application/json'},
      );

      var responseData = json.decode(response.body);

      if(responseData['data'] != null){
        // provider에 유저 정보 추가
        setting.setUser(UserData(id: responseData['data']['id'], email: responseData['data']['email'], name: responseData['data']['name'], role: responseData['data']['role']));
        setting.setIndex(0);

        if(responseData['data']['role'] == 0){ // 0이면 유저페이지
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserMainScreen()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminMainScreen()));
        }

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