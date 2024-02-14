
import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/login_screen/login_screen.dart';
import 'package:car_project/screens/logo_screen/logo_screens.dart';
import 'package:car_project/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';





void main(){
  WidgetsFlutterBinding.ensureInitialized(); // MedeaQuery 사용을 위한 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => Setting(),
      child: MaterialApp(
        home: LoginScreen(),
      )
    );
  }
}

class Setting with ChangeNotifier{
  UserData? _user;

  UserData? get user => _user;

  void setUser(UserData user){
    _user = user;
    notifyListeners();
  }
}