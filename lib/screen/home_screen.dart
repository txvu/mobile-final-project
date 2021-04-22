import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_comment.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/widget/my_bottom_navigation_bar.dart';
import 'package:cmsc4303_lesson3/widget/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/screen/signup_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:cmsc4303_lesson3/widget/my_drawer.dart';
import 'package:cmsc4303_lesson3/widget/photo_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/my_image.dart';

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

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'PHOTO MEMOS',
          style: TextStyle(fontFamily: 'Lobster', fontSize: 20.0),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(30),
        //   ),
        // ),
      ),
      drawer: MyDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Constant.PHOTO_MEMO_COLLECTION)
            .where(PhotoMemo.IS_PUBLIC, isEqualTo: true)
            .orderBy(PhotoMemo.TIMESTAMP, descending: true)
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
      bottomNavigationBar: MyBottomNavigationBar(0),
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
