import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:http/http.dart' as http;

Future<void> complete(int carId) async {
  try{
    var url = Uri.parse('${URI()}/car/complete'); // PATCH로 변경

    var request = {'car_id': carId};

    var response = await http.patch(
      url, body: json.encode(request), headers: {'Content-type': 'application/json'},
    );

    print(response);
  }catch(e){
    print(e);
  }
}
