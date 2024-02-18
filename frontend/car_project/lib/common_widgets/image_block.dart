import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';

Widget buildImage(String imagePath){
  if(kIsWeb) {
    return Image.network(imagePath);
  } else {
    return Image.file(File(imagePath), );
  }
}
