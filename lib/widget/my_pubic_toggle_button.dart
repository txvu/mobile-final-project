
import 'package:cmsc4303_lesson3/provider/reference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPublishToggleButton extends StatefulWidget {
  @override
  _MyPublishToggleButtonState createState() => _MyPublishToggleButtonState();
}

class _MyPublishToggleButtonState extends State<MyPublishToggleButton> {
  List<bool> isSelected = [false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30.0),
      borderColor: Colors.white38,
      selectedBorderColor: Colors.blue,
      borderWidth: 1.0,
      selectedColor: Colors.blue,
      textStyle: TextStyle(color: Colors.white12, fontSize: 12.0,),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 10.0),
          child: Text('   Make   \n   Public   ',),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          isSelected[index] = !isSelected[index];
          Provider.of<Reference>(context, listen: false).makePublic = isSelected[index];
          print(Provider.of<Reference>(context, listen: false).makePublic);
        });
      },
      isSelected: isSelected,
    );
  }
}
