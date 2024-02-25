import 'dart:async';

import 'package:car_project/main.dart';
import 'package:car_project/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoScreen extends StatefulWidget {

  LogoScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  String _textToShow = '';
  int _currentIndex = 0;
  bool _containerVisible = false;
  bool _hi = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _startTextAnimation();
  }

  void _startTextAnimation() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if (_currentIndex < 'CHABAO'.length) {
          _textToShow = 'CHABAO'.substring(0, _currentIndex + 1);
          _currentIndex++;
        } else {
          timer.cancel();
          _showContainerAfterDelay();
        }
      });
    });
  }

  void _showContainerAfterDelay() {
    _controller.forward();
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _containerVisible = true;
        Timer(Duration(milliseconds: 1500), (){
          setState(() {
            _hi = true;
          });
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final setting = Provider.of<Setting>(context);

    // 설정한 시간동안 보여주고 다음 페이지로 이동, 다른 페이지의 로딩을 자연스럽게 하기 위해 추가함
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 300,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: Text(
                    _textToShow,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: AnimatedOpacity(
              opacity: _containerVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Center(
                child: Container(
                  height: 250,
                  width: 200,
                  child: Stack(
                    children: [
                      Image.asset('assets/images/chabao_before.png'),
                      _hi ? Image.asset('assets/images/chabao.png') : SizedBox.shrink(),
                    ],
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
