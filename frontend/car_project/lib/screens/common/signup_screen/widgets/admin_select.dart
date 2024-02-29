
import 'package:flutter/material.dart';

class AdminSelectWidget extends StatefulWidget{
  final Function(int) onSelectionChanged;

  AdminSelectWidget({required this.onSelectionChanged});

  @override
  _AdminSelectWidgetState createState() => _AdminSelectWidgetState();
}

class _AdminSelectWidgetState extends State<AdminSelectWidget>{
  int? _selectItem;

  List<String> list = ['고객', '업체'];
  List<int> valueList = [0, 1];

  @override
  Widget build(BuildContext context){
    return Container(
        width: 400,
        height: 70,
        child: DropdownButton<int>(
          focusColor: Colors.transparent,
          style: TextStyle(fontSize: 16, color: Colors.black),
          icon: SizedBox(),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          // underline: SizedBox(),
          isExpanded: true,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          hint: Text("역할을 선택해주세요."),
          alignment: Alignment.center,
          value: _selectItem,
          items: List.generate(list.length, (index) {
            return DropdownMenuItem<int>(
              alignment: Alignment.center,
              value: valueList[index], child: Text(list[index]),);
          }),
          onChanged: (int? newValue){
            setState(() {_selectItem = newValue;});
            widget.onSelectionChanged(_selectItem!);
          },
        )
    );
  }
}