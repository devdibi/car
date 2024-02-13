
import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier{
  int? id;
  String? email;
  String? name;

  void setUserInfo(int id, String email, String name){
    this.id = id;
    this.email = email;
    this.name = name;
    notifyListeners();
  }
}