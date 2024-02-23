import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animated Text Demo'),
        ),
        body: Center(
          child: AnimatedText(),
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // 애니메이션 지속 시간 설정
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.7, curve: Curves.easeInOut), // 각 글자가 나타나는 간격 조절
      ),
    );

    _controller.forward(); // 애니메이션 시작
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int index = (_animation.value * 6).floor(); // 글자 개수에 따라 수정
        String textToShow = 'CHABAO'.substring(0, index);

        return Text(
          textToShow,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
