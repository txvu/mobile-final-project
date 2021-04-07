import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/home_screen.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_image.dart';
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Shared With Me'),
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
      // body: photoMemoList.length == 0
      //     ? Text(
      //         'No PhotoMemos shared with me.',
      //         style: Theme.of(context).textTheme.headline5,
      //       )
      //     : ListView.builder(
      //         itemCount: photoMemoList.length,
      //         itemBuilder: (context, index) => Card(
      //           elevation: 7.0,
      //           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //             Center(
      //               child: Container(
      //                 height: MediaQuery.of(context).size.height * 0.4,
      //                 child: MyImage.network(
      //                   url: photoMemoList[index].photoURL,
      //                   context: context,
      //                 ),
      //               ),
      //             ),
      //             Text(
      //               'Title: ${photoMemoList[index].title}',
      //               style: Theme.of(context).textTheme.headline6,
      //             ),
      //             Text(
      //               'Memo: ${photoMemoList[index].memo}',
      //               // style: Theme.of(context).textTheme.headline6,
      //             ),
      //             Text(
      //               'Created By: ${photoMemoList[index].createdBy}',
      //               // style: Theme.of(context).textTheme.headline6,
      //             ),
      //             Text(
      //               'Updated At: ${photoMemoList[index].timestamp}',
      //               // style: Theme.of(context).textTheme.headline6,
      //             ),
      //             Text(
      //               'Shared With: ${photoMemoList[index].sharedWith}',
      //               // style: Theme.of(context).textTheme.headline6,
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 FutureBuilder(
      //                   future:
      //                       controller.getNumberOfComments(photoMemoList[index].photoURL),
      //                   builder: (context, snapshot) {
      //                     if (snapshot.hasData) {
      //                       if (snapshot.data > 0) {
      //                         return Container(
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(5),
      //                             color: Colors.red,
      //                           ),
      //                           child: Text(
      //                             ' ${snapshot.data.toString()} ',
      //                             style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontSize: 14.0,
      //                                 fontWeight: FontWeight.bold),
      //                           ),
      //                         );
      //                       } else {
      //                         return SizedBox(
      //                           height: 1,
      //                         );
      //                       }
      //                     } else {
      //                       return SizedBox(
      //                         height: 1,
      //                       );
      //                     }
      //                   },
      //                 ),
      //                 IconButton(
      //                   icon: Icon(Icons.message),
      //                   onPressed: () => controller.gotoComments(
      //                     photoMemoList[index].photoURL,
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ]),
      //         ),
      //       ),
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
