
import 'package:flutter/material.dart';

class SelectWidget extends StatefulWidget{
  final Function(String?) onSelectionChanged;

  SelectWidget({required this.onSelectionChanged});

  @override
  _SelectWidgetState createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget>{
  String? _selectItem;

  List<String> list = ['GENESIS G90', 'HYUNDAI AVENTE', 'HYUNDAI GRANDEUR', 'HYUNDAI IONIQ5', 'HYUNDAI IONIQ6', 'HYUNDAI KONA', 'HYUNDAI SANTAFE', 'HYUNDAI SONATA', 'HYUNDAI TUCSON', 'KIA EV6', 'KIA EV9', 'KIA K3', 'KIA K5', 'KIA K9', 'KIA MORNING', 'KIA NIRO', 'KIA SELTOS', 'KIA SORENTO', 'KIA SPORTAGE'];
  List<String> valueList = ['G90', 'AVENTE', 'GRANDEUR', 'IONIQ5', 'IONIQ6', 'KONA', 'SANTAFE', 'SONATA', 'TUCSON', 'EV6', 'EV9', 'K3', 'K5', 'K9', 'MORNING', 'NIRO', 'SELTOS', 'SORENTO', 'SPORTAGE'];

  @override
  Widget build(BuildContext context){
    return Container(
          width: 400,
          height: 70,
          child: DropdownButton<String>(
              focusColor: Colors.transparent,
              style: TextStyle(fontSize: 16),
              icon: SizedBox(),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              // underline: SizedBox(),
              isExpanded: true,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              hint: Text("차종을 선택해 주세요"),
              alignment: Alignment.center,
              value: _selectItem,
              items: List.generate(list.length, (index) {
                return DropdownMenuItem<String>(
                  alignment: Alignment.center,
                  value: valueList[index], child: Text(list[index]),);
              }),
              onChanged: (String? newValue){
                setState(() {_selectItem = newValue;});
                widget.onSelectionChanged(newValue);
              },
          )
      );
  }
}