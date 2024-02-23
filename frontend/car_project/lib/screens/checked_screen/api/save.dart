import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:http/http.dart' as http;

Future<void> save (int carId, int section, int checkValue) async {
  try{
    var url = Uri.parse('${URI()}/check/save'); // PATCH로 변경

    var request = {'car_id': carId,'section': section, 'check_value': checkValue};

    var response = await http.patch(
      url, body: json.encode(request), headers: {'Content-type': 'application/json'},
    );

    print(response);
  }catch(e){
    print(e);
  }
}