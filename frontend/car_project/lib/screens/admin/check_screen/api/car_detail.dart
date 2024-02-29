
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:car_project/common/url.dart';
import 'package:flutter/material.dart';

Future<void> carDetail(BuildContext context, int carId) async{
  try{
    var url = Uri.parse('${URI()}/car/detail/$carId'); // POST 요청

    var response = await http.get(
      url, headers: {'Content-type': 'application/json'},
    );

    var responseData = json.decode(response.body);

    print(responseData);
  }catch(e){
    print(e);

  }
}