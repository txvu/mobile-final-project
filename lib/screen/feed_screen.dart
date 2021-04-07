import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomemo.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/signup_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myview/my_image.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = '/feed_screen';
  final user = FirebaseAuth.instance.currentUser;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  _Controller controller;
  GlobalKey<FormState> formKey = GlobalKey();

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

            return ListView.builder(
              itemCount: publishedPhotos.length,
              // reverse: true,
              itemBuilder: (ctx, index) => Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white30, width: 1.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.white12,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User:' +
                                      publishedPhotos[index]
                                          .data()[PhotoMemo.CREATED_BY]
                                          .toString()
                                          .split('@')[0],
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  publishedPhotos[index]
                                      .data()[PhotoMemo.CREATED_BY],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Center(
                        child: MyImage.network(
                          url: publishedPhotos[index]
                              .data()[PhotoMemo.PHOTO_URL],
                          context: context,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      child: Text(
                        publishedPhotos[index].data()[PhotoMemo.TITLE],
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, right: 10.0, left: 10.0),
                      child: Text(
                        publishedPhotos[index]
                                .data()[PhotoMemo.MEMO]
                                .toString()
                                .substring(0, 50) +
                            '...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue,),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.insert_comment_outlined, color: Colors.blue,),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.share_outlined, color: Colors.blue,),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          print(publishedPhotosSnapshot.error.toString());
          return Text(publishedPhotosSnapshot.error.toString());
        },
      ),
    );
  }
}

class _Controller {
  _FeedScreenState state;

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
