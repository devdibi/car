

import 'dart:convert';
import 'dart:io';

import 'package:car_project/common/url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


File? selectedFile;

// 파일 선택
Future<String> selectFile(File file, int sectionId, int section) async {
  // 파일 선택 로직 구현
  selectedFile = file;
  return await _uploadFile(selectedFile!, sectionId, section);
}

// 파일 업로드
Future<String> _uploadFile(File file, int sectionId, int section) async {
  if (file == null) {
    // 업로드할 파일이 선택되지 않은 경우
    return "파일이 없습니다.";
  }

  // 파일 업로드 로직 구현
  var uri = Uri.parse('${URI()}/car/upload');

  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('file', file.path))
    ..fields['section_id'] = sectionId.toString()
    ..fields['section'] = section.toString();

  var response = await request.send();

  var responseBody = json.decode(await response.stream.bytesToString());

  return responseBody['data']['image_path'];

}