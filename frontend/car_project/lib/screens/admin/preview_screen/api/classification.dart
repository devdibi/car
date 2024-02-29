import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:http/http.dart' as http;


Future<void> classification(int sectionId, section) async{
  try{
    var url = Uri.parse('${URI()}/car/classification'); // POST 요청

    var request = {'section_id': sectionId, 'section': section};

    var response = await http.patch(
      url, body: json.encode(request), headers: {'Content-type': 'application/json'},
    );

    var responseData = json.decode(response.body)['data'];
    print("classification 완료 :  $responseData");
  }catch(e){
    print(e);
  }
}