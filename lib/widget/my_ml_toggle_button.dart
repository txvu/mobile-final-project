import 'package:cmsc4303_lesson3/provider/reference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyMLToggleButton extends StatefulWidget {
  @override
  _MyMLToggleButtonState createState() => _MyMLToggleButtonState();
}

class _MyMLToggleButtonState extends State<MyMLToggleButton> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30.0),
      borderColor: Colors.white38,
      selectedBorderColor: Colors.blue,
      borderWidth: 1.0,
      selectedColor: Colors.blue,
      textStyle: TextStyle(color: Colors.white12, fontSize: 12.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 10.0),
          child: Text('Image\nLabeler',),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
          child: Text('Text\nRecognition'),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            if (i != index && isSelected[i] == true) {
              isSelected[i] = false;
            }
          }
          isSelected[index] = !isSelected[index];
          Provider.of<Reference>(context, listen: false).enableImageLabeler = isSelected[0];
          Provider.of<Reference>(context, listen: false).enableTextRecognition = isSelected[1];
          print('enableImageLabeler: ${Provider.of<Reference>(context, listen: false).enableImageLabeler}');
          print('enableTextRecognition: ${Provider.of<Reference>(context, listen: false).enableTextRecognition}');
        });
      },
      isSelected: isSelected,
    );
  }
}
