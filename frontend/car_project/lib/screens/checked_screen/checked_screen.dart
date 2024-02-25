import 'dart:convert';
import 'dart:io';
import 'package:car_project/common/url.dart';
import 'package:car_project/common/height.dart';
import 'package:car_project/common_widgets/common_box.dart';
import 'package:car_project/screens/check_screen/check_screen.dart';
import 'package:car_project/screens/checked_screen/api/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CheckedScreen extends StatefulWidget{
  @override
  _CheckedScreenState createState() => _CheckedScreenState();

  double pWidth = 0;
  double pHeight = 0;

  String? link;
  final int section;
  final int sectionId;
  final int carId;

  CheckedScreen({
    Key? key,
    required this.section,
    required this.sectionId,
    required this.carId
  }) : super(key: key);
}

class _CheckedScreenState extends State<CheckedScreen>{
  bool _isLoading = false;
  List<Widget> info = [];
  int total = 0;
  List<Map<String, double>> bound = [];


  @override
  void initState() {
    super.initState();
    carDetail(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    widget.pHeight = MediaQuery.of(context).size.height * 0.4;
    widget.pWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading:false),
      body: _isLoading ? Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height:MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Stack(
                  children: [
                    Container(
                      height:MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.link!, fit: BoxFit.fitWidth,)
                    ),
                    ListView.builder(
                      itemCount: bound.length,
                      itemBuilder: (context, index){
                        return Container(
                            height:MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: info.isNotEmpty && bound.isNotEmpty ? CustomPaint(
                                painter: BoundingBoxPainter(bound[index]['x_min']!, bound[index]['x_max']!, bound[index]['y_min']!, bound[index]['y_max']!)
                            ) : SizedBox()
                        );
                      },
                    )

                  ],
                )

              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: info.length != 0 ? [info[0], SizedBox(width:10), info[1]] : [],),
                    Height(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: info.length != 0 ? [info[2], SizedBox(width:10), info[3]] : [],)
                  ],),
                )
              ),
              total != 0 ? Text("총 ${total}개의 차량 손상이 발견되었습니다.") : Text("차량 파손이 없습니다."),
              Height(height: 20),
              Container(
                width: MediaQuery.of(context).size.width -20,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    // 손상 값
                    int checkValue = 1;
                    await save(widget.carId, widget.section, checkValue);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckScreen(carId: widget.carId,)));
                    },
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(88, 88, 88, 100)),
                    fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width , 60)),
                    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.white)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      elevation: MaterialStateProperty.all(2)
                  ),
                  child: Text("저장하기", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ),
              Height(height: 20),
            ],
          )
      ) : Center(child: CircularProgressIndicator())
    );
  }


  Future<void> carDetail(BuildContext context) async{
    try{
      var imageUrl = Uri.parse('${URI()}/car/section/${widget.sectionId}');

      var imageResponse = await http.get(
        imageUrl, headers: {'Content-type': 'application/json'},
      );

      var image = json.decode(imageResponse.body)['data'];

      widget.link = image['image_path']; // 이미지의 경로

      var url = Uri.parse('${URI()}/car/crack/${widget.sectionId}');

      var response = await http.get(
        url, headers: {'Content-type': 'application/json'},
      );

      var responseData = json.decode(response.body)['data'];

      print(responseData);

      Map<String, int> data = {
        "scratched" : 0,
        "crushed" : 0,
        "breakage" : 0,
        "separated" :0
      };

      List<Map<String, double>> boxes = [];

      for(int i = 0; i < responseData.length; i++){
        if(responseData[i]['degree'] == 0){
          data['scratched'] = data['scratched']! + 1;
        }else if(responseData[i]['degree'] == 1){
          data['crushed'] = data['crushed']! + 1;
        }else if(responseData[i]['degree'] == 2){
          data['breakage'] = data['breakage']! + 1;
        }else if(responseData[i]['degree'] == 3){
          data['separated'] = data['separated']! + 1;
        }

        Map<String, double> box = {
          "x_min" : responseData[i]['x_min'] * widget.pWidth,
          "x_max" : responseData[i]['x_max'] * widget.pWidth,
          "y_min" : responseData[i]['y_min'] * widget.pHeight,
          "y_max" : responseData[i]['y_max'] * widget.pHeight
        };
        print(box);

        boxes.add(box);
      }
      print(boxes);

      List<Widget> tempList = [];

      tempList.add(Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(200, 200, 200, 100), // 그림자의 색상
              offset: Offset(2, 3), // 그림자의 위치 (가로, 세로)
              blurRadius: 2, // 그림자의 흐림 정도
              spreadRadius: 1, // 그림자의 확산 정도
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(230, 230, 230, 100),
        ),
        width: 100,
        height: 100,
        child: Column(
          children: [
            Text("스크래치"),
            Container(height: 1, color: Colors.black,),
            Text("${data['scratched']}", style: TextStyle(fontSize: 30),)
          ],
        ),
      ));
      tempList.add(Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(200, 200, 200, 100), // 그림자의 색상
              offset: Offset(2, 3), // 그림자의 위치 (가로, 세로)
              blurRadius: 2, // 그림자의 흐림 정도
              spreadRadius: 1, // 그림자의 확산 정도
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(230, 230, 230, 100),
        ),
        width: 100,
        height: 100,
        child: Column(
          children: [
            Text("찌그러짐"),
            Container(height: 1, color: Colors.black,),
            Text("${data['crushed']}", style: TextStyle(fontSize: 30),)
          ],
        ),
      ));
      tempList.add(Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(200, 200, 200, 100), // 그림자의 색상
              offset: Offset(2, 3), // 그림자의 위치 (가로, 세로)
              blurRadius: 2, // 그림자의 흐림 정도
              spreadRadius: 1, // 그림자의 확산 정도
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(230, 230, 230, 100),
        ),
        width: 100,
        height: 100,
        child: Column(
          children: [
            Text("파손"),
            Container(height: 1, color: Colors.black,),
            Text("${data['breakage']}", style: TextStyle(fontSize: 30),)
          ],
        ),
      ));
      tempList.add(Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(200, 200, 200, 100), // 그림자의 색상
              offset: Offset(2, 3), // 그림자의 위치 (가로, 세로)
              blurRadius: 2, // 그림자의 흐림 정도
              spreadRadius: 1, // 그림자의 확산 정도
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(230, 230, 230, 100),
        ),
        width: 100,
        height: 100,
        child: Column(
          children: [
            Text("이격"),
            Container(height: 1, color: Colors.black,),
            Text("${data['separated']}", style: TextStyle(fontSize: 30),)
          ],
        ),
      ));

      int count = data["scratched"]! + data["crushed"]! + data["breakage"]! + data["separated"]!;

      setState(() {
        info = tempList;
        total = count;
        bound = boxes;
        _isLoading = true;
      });


      print(data);
    }catch(e){
      print(e);
    }
  }
}