import 'package:car_project/model/user_data.dart';
import 'package:car_project/screens/common/logo_screen/logo_screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
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
  int _currentIndex = 0;

  UserData? get user => _user;
  int? get currentIndex => _currentIndex;

  void setUser(UserData user){
    _user = user;
    notifyListeners();
  }

  void setIndex(int index){
    _currentIndex = index;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _currentIndex = 0;
    notifyListeners();
  }
}