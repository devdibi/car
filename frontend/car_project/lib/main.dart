import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/logo_screen/logo_screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized()을 호출하여 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => Setting(),
      child: MaterialApp(
        title: "차바오",
        home: LogoScreen(),
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