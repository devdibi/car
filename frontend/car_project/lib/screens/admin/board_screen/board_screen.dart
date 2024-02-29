
import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BoardScreen extends StatefulWidget {

  final int carId;

  @override
  _BoardScreenState createState() => _BoardScreenState();

  BoardScreen({
    Key? key,
    required this.carId
  }) : super(key: key);
}

class _BoardScreenState extends State<BoardScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<int> direction = [0,9,18,27];
  String? carType;
  List<Widget> wids = [];
  bool _isLoading = false; // 데이터 로딩 중임을 나타내는 상태 추가
  List<List<Widget>>boxes = [];
  List<Map<String, double>>? paintBoxes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carInfo(context);
    box(context);
    setState(() {
      _isLoading = true;
    });
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _pageController.addListener((){
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }



  @override
  Widget build(BuildContext context){
    return _isLoading ? Scaffold(
      appBar: AppBar(
        title: Text("차량 정보"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 30),
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              child: PageView(
                controller: _pageController,
                children: wids,
              ),
            ),

            // 페이지 표시 구간
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i
                          ? Color.fromRGBO(150, 150, 150, 100)
                          : Color.fromRGBO(230, 230, 230, 100),
                    ),
                  ),
              ],
            )
          ],
        ),
      )
    ): Center(child: CircularProgressIndicator());
  }
  Map<String, int> data = {
    "scratched" : 0,
    "crushed" : 0,
    "breakage" : 0,
    "separated" :0
  };

  Map<int, String> map = {
    0 : '스크래치',
    1 : '찌그러짐',
    2 : '파손',
    3 : '이격'
  };

  Future<void> carInfo(BuildContext context) async {
    try{
      // image
      var imageUrl = Uri.parse("${URI()}/crack/detail/${widget.carId}");

      var response = await http.get(
        imageUrl, headers: {'Content-type': 'application/json'},
      );

      var responseData = json.decode(response.body);

      var cracks = responseData['data']['crack_list'];


      List<Widget> screens = [];

      for(int i = 0; i < 4; i++){
        var path = cracks[i]['image_path'];

        List<int> list = [];

        for(int j = 0; j < 4; j++){
          list.add(cracks[i]['crack']['$j']);
        }

        screens.add(screen(path, list, i));
      }
      setState(() {
        wids = screens;
      });

    }catch(e){
      print(e);
    }
  }

  Widget screen(String path, List<int> list, int i) {
    int total = list[0] + list[1] + list[2] + list[3];
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                width: 400,
                child: Image.network(path),
              ),
              CustomPaint(
                painter: BoundingBoxPainter(paintBoxes![i]['xMin']!,paintBoxes![i]['xMax']!,paintBoxes![i]['yMin']!,paintBoxes![i]['yMax']!),
              )
            ],
          ),
          SizedBox(height: 50,),
          Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      card(map[0]!, list[0]),
                      SizedBox(width: 20,),
                      card(map[1]!, list[1]),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      card(map[2]!, list[2]),
                      SizedBox(width: 20,),
                      card(map[3]!, list[3]),
                    ],
                  ),
                ],
              ),
              Positioned.fill(
                child: total == 0
                    ? Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 200,
                    color: Colors.green.withOpacity(0.3),
                  ),
                )
                    : Center(
                  child: Icon(
                    Icons.warning_amber_outlined,
                    size: 200,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50,),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: total != 0
                  ? Text(
                '${total}개의 차량 손상이 발견되었습니다.',
                style: TextStyle(fontSize: 20),
              )
                  : Text(
                '차량 손상이 없습니다.',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }


  Widget card(String title, int n){
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(200, 200, 200, 100), // 그림자의 색상
            offset: Offset(2, 3), // 그림자의 위치 (가로, 세로)
            blurRadius: 2, // 그림자의 흐림 정도
            spreadRadius: 1, // 그림자의 확산 정도
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(230, 230, 230, 100),
      ),
      height: 100,
      width: 100,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text(title , style: TextStyle(fontSize: 20),),
          SizedBox(height: 10,),
          Container(width: 90, color: Colors.black, height: 1,),
          SizedBox(height: 20,),
          Text('$n', style: TextStyle(fontSize: 20),)
        ],
      ),
    );
  }

  Future<void> box(BuildContext context) async {
    try{
      var url = Uri.parse("${URI()}/crack/box/${widget.carId}");

      var response = await http.get(
          url,  headers: {'Content-type': 'application/json'}
      );

      var responseData = json.decode(response.body);

      var boxes = responseData['data'];

      List<Map<String, double>>  tempBox= [];

      for(int i = 0; i < 4; i++){
        tempBox.add({
          'xMin' : 0.0,
          'xMax' : 0.0,
          'yMin' : 0.0,
          'yMax' : 0.0
        });
      }

      for (int i = 0; i < boxes.length; i++) {
        int section = boxes[i]['section'];
        double xMin = boxes[i]['x_min'] * 400;
        double xMax = boxes[i]['x_max'] * 400;
        double yMin = boxes[i]['y_min'] * 300;
        double yMax = boxes[i]['y_max'] * 300;

        var box = {
          'xMin' : xMin,
          'xMax' : xMax,
          'yMin' : yMin,
          'yMax' : yMax
        };
        tempBox[section] = box;

      }
      print(tempBox);

      setState(() {
        paintBoxes = tempBox;
      });
    }catch(e) {
      print(e);
    }
  }
}

class BoundingBoxPainter extends CustomPainter {
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  BoundingBoxPainter(this.xMin, this.xMax, this.yMin, this.yMax);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outlinePaint = Paint()
      ..color = Colors.red // 선의 색상을 빨간색으로 설정
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke; // 선으로 설정

    Paint fillPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.5) // 내부의 색상을 흰색으로 설정하고 투명도를 조절
      ..style = PaintingStyle.fill; // 내부를 채우는 스타일로 변경

    double width = xMax - xMin;
    double height = yMax - yMin;

    // 내부를 채우는 사각형 그리기
    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      fillPaint,
    );

    // 외곽선을 그리는 사각형 그리기
    canvas.drawRect(
      Rect.fromLTRB(xMin, yMin, xMax, yMax),
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
