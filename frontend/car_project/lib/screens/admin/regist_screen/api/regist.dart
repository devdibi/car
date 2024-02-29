import 'package:car_project/model/car_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<int> registCar(BuildContext context, CarData car) async{

  final setting = Provider.of<Setting>(context, listen: false);

  try{
    var url = Uri.parse('${URI()}/car/register'); // POST 요청

    var request = {'user_id': setting.user!.id, 'car_number' : car.carNumber, 'car_type' : car.carType};

    var response = await http.post(
      url, body: json.encode(request), headers: {'Content-type': 'application/json'},
    );

    var responseData = json.decode(response.body)['data'];
    print("차량 등록 완료 :  $responseData");
    return responseData['car_id'];
  }catch(e){
    print(e);
    return -1;
  }
}
