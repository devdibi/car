import 'dart:convert';

import 'package:car_project/common/url.dart';
import 'package:car_project/screens/board_screen/widgets/board.dart';
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

  @override
  void initState() {
    carDetail(context); // 페이지 초기화
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("차량 정보"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
        carType == null && wids.length < 4? Center(child: CircularProgressIndicator()) :
      Container(
        // padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width * 0.9,
              child: PageView(
                controller: _pageController,
                children: wids,
              ),
            ),
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
                      color: _currentPage == i ? Color.fromRGBO(150, 150, 150, 100) : Color.fromRGBO(230, 230, 230, 100),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget card(int i, int sectionId, int carId, String link) {
    return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 50),
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
                child: Container(
                  margin: EdgeInsets.fromLTRB(50, 30, 50, 30),
                  width: 500,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: BoardWidget(section: i, sectionId: sectionId, carId: carId, link: link, ),
                ),
          );

  }

  Future<void> carDetail(BuildContext context) async{

    try{
      var url = Uri.parse('${URI()}/car/detail/${widget.carId}'); // POST 요청

      var response = await http.get(
        url, headers: {'Content-type': 'application/json'},
      );

      var responseData = json.decode(response.body)['data'];

      print(responseData);

      List<Widget> temp = [];

      for(int i = 0; i < 4; i++){
        temp.add(card(i, responseData['sections'][i]['id'], widget.carId, responseData['sections'][i]['image_path']));
      }

      print(temp);

      setState(() { // 상태 갱신
        carType = responseData['car_type']; // 상태 갱신
        wids = temp;
      });
    }catch(e){
      print(e);
    }
  }
}
