import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/home_screen.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  MyBottomNavigationBar(this.selectedIndex);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.of(context).pushNamed(HomeScreen.routeName);
        break;
      case 1:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.of(context).pushNamed(AddPhotoMemoScreen.routeName);
        break;
      case 2:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.of(context).pushNamed(UserHomeScreen.routeName);
        break;
      case 3:
        setState(() {
          _selectedIndex = index;
        });
        Navigator.of(context).pushNamed(SharedWithScreen.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.selectedIndex;
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Public',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo_outlined),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'My Photo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add_outlined),
          label: 'Share With Me',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
