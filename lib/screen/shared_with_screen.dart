import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/home_screen.dart';
import 'package:cmsc4303_lesson3/widget/my_bottom_navigation_bar.dart';
import 'package:cmsc4303_lesson3/widget/my_drawer.dart';
import 'package:cmsc4303_lesson3/widget/my_image.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_comments_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:cmsc4303_lesson3/widget/photo_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';

import '../model/photo_comment.dart';
import 'detailedview_screen.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/shared_with_screen';

  @override
  _SharedWithScreenState createState() => _SharedWithScreenState();
}

class _SharedWithScreenState extends State<SharedWithScreen> {
  _Controller controller;
  User user;
  List<PhotoMemo> photoMemoList;

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user = FirebaseAuth.instance.currentUser;
    int _selectedIndex = 3;
    // photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    photoMemoList = [];

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SHARED WITH ME',
          style: TextStyle(fontFamily: 'Lobster', fontSize: 20.0),
        ),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: MyBottomNavigationBar(3),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Constant.PHOTO_MEMO_COLLECTION)
            .where(PhotoMemo.SHARED_WITH, arrayContains: user.email)
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
    );
  }
}

class _Controller {
  _SharedWithScreenState state;
  List<PhotoComment> comments = [];

  _Controller(this.state);

  // creating on tap event similiar to user_home_screen
  void onTap(int index) async {
    await Navigator.pushNamed(
      state.context,
      DetailedViewScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index]
      },
    );
    state.render(() {});
  }

  // end creating on tap event similiar to user_home_screen

  //test
  void gotoComments(photoUrl) async {
    try {
      //String url = photo_url;
      await Navigator.pushNamed(
        state.context,
        SharedWithComments.routeName,
        arguments: {
          Constant.ARG_USER: state.user,
          Constant.ARG_ONE_PHOTOMEMO: photoUrl,
        },
      );
      Navigator.of(state.context).pop();
    } catch (e) {
      print('oops');
    }
  }

  Future<int> getNumberOfComments(String URL) async {
    int value = 0;
    await getMessages(URL);
    value = comments.length;
    return value;
  }

  Future<void> getMessages(String URL) async {
    print('im here');
    comments = await FirebaseController.getPhotoComments(photoURL: URL);
    print('im here2222n----> ${comments.length}');

    for (int i = 0; i < comments.length; i++) {
      print(comments[i].comments.toString());
    }
    print('im here3333');
  }
//test
}
