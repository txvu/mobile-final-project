import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_comment.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/screen/signup_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:cmsc4303_lesson3/widget/photo_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myview/my_image.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/feed_screen';
  final user = FirebaseAuth.instance.currentUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _Controller controller;
  GlobalKey<FormState> formKey = GlobalKey();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

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
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Photo Memos',
          style: TextStyle(fontFamily: 'Lobster', fontSize: 28.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Icon(Icons.person, size: 100.0),
              // accountName: Text(user.displayName ?? 'N/A'),
              // accountEmail: Text(user.email),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Shared With Me'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: controller.signOut,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: null,
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('photo_memos')
            .where('is_published', isEqualTo: true)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (ctx, publishedPhotosSnapshot) {
          if (publishedPhotosSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Container();
          }
          if (publishedPhotosSnapshot.hasData) {
            final publishedPhotos = publishedPhotosSnapshot.data.docs;
            if (publishedPhotos.length == 0) {
              return Center(
                child: Text(
                  'Empty',
                  style: TextStyle(
                    fontSize: 70,
                    color: Colors.white24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else
              return ListView.builder(
                  itemCount: publishedPhotos.length,
                  // reverse: true,
                  itemBuilder: (ctx, index) => PhotoTile(PhotoMemo.deserialize(
                      publishedPhotos[index].data(),
                      publishedPhotos[index].id)));
          }
          print(publishedPhotosSnapshot.error.toString());
          return Text(publishedPhotosSnapshot.error.toString());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
      ),
    );
  }
}

class _Controller {
  _HomeScreenState state;

  _Controller(this.state);

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }
    Navigator.of(state.context).pop();
    // Navigator.of(state.context).pop();
  }
}
