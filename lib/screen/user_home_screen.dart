import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/detailedview_screen.dart';
import 'package:cmsc4303_lesson3/screen/home_screen.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/widget/photo_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myview/my_image.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/user_home_screen';

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  _Controller controller;
  User user = FirebaseAuth.instance.currentUser;
  List<PhotoMemo> photoMemoList;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    // user ??= agrs[Constant.ARG_USER];
    // photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    photoMemoList = [];
    int _selectedIndex = 2;

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

    return WillPopScope(
      onWillPop: () => Future.value(false), // Disable android back button
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          // title: Text('User Home'),

          actions: [
            controller.delIndex != null
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: controller.cancelDelete,
                  )
                : Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Search',
                            fillColor: Colors.black54,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                controller.search();
                              },
                            ),
                          ),
                          autocorrect: true,
                          onSaved: controller.saveSearchKeyString,
                        ),
                      ),
                    ),
                  ),
            controller.delIndex != null
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: controller.delete,
                  )
                : SizedBox(
                    height: 1,
                    width: 45.0,
                  ),
          ],
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
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Icon(Icons.person, size: 100.0),
                accountName: Text(user.displayName ?? 'N/A'),
                accountEmail: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Shared With Me'),
                onTap: controller.sharedWithMe,
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
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: controller.addButton,
        // ),
        // body: photoMemoList.length == 0
        //     ? Text(
        //         'No PhotoMemo Found!',
        //         style: Theme.of(context).textTheme.headline5,
        //       )
        //     : ListView.builder(
        //         itemCount: photoMemoList.length,
        //         itemBuilder: (BuildContext context, int index) => Container(
        //           color: controller.delIndex != null &&
        //                   controller.delIndex == index
        //               ? Theme.of(context).highlightColor
        //               : Theme.of(context).scaffoldBackgroundColor,
        //           child: ListTile(
        //             leading: MyImage.network(
        //               url: photoMemoList[index].photoURL,
        //               context: context,
        //             ),
        //             trailing: Icon(Icons.keyboard_arrow_right),
        //             title: Text(photoMemoList[index].title),
        //             subtitle: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   photoMemoList[index].memo.length >= 20
        //                       ? photoMemoList[index].memo.substring(0, 20) +
        //                           '...'
        //                       : photoMemoList[index].memo,
        //                 ),
        //                 Text('created By:  ${photoMemoList[index].createdBy}'),
        //                 Text('Shared With: ${photoMemoList[index].sharedWith}'),
        //                 Text('Updated At: ${photoMemoList[index].timestamp}'),
        //               ],
        //             ),
        //             onTap: () => controller.onTap(index),
        //             onLongPress: () => controller.onLongPress(index),
        //           ),
        //         ),
        //       ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(Constant.PHOTO_MEMO_COLLECTION)
              .where(PhotoMemo.CREATED_BY, isEqualTo: user.email)
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
                    itemBuilder: (ctx, index) => PhotoTile(
                        PhotoMemo.deserialize(publishedPhotos[index].data(),
                            publishedPhotos[index].id)));
            }
            print(publishedPhotosSnapshot.error.toString());
            return Text(publishedPhotosSnapshot.error.toString());
          },
        ),
      ),
    );
  }
}

class _Controller {
  _UserHomeScreenState state;
  int delIndex;
  String keyString;

  _Controller(this.state);

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
  }

  void addButton() async {
    await Navigator.of(state.context)
        .pushNamed(AddPhotoMemoScreen.routeName, arguments: {
      Constant.ARG_USER: state.user,
      Constant.ARG_PHOTOMEMOLIST: state.photoMemoList,
    });
    state.render(() {}); // render the screen
  }

  void onTap(int index) async {
    if (delIndex != null) return;
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

  void sharedWithMe() async {
    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoSharedWithMe(
              email: state.user.email);
      await Navigator.pushNamed(
        state.context,
        SharedWithScreen.routeName,
        arguments: {
          Constant.ARG_USER: state.user,
          Constant.ARG_PHOTOMEMOLIST: photoMemoList,
        },
      );
      Navigator.of(state.context).pop();
    } catch (e) {
      print(e.toString());
      MyDialog.info(
        context: state.context,
        title: 'Get Shared PhotoMemo Error',
        content: '$e',
      );
    }
  }

  void onLongPress(int index) {
    if (delIndex != null) return;
    state.render(() => delIndex = index);
  }

  void cancelDelete() {
    state.render(() => delIndex = null);
  }

  void delete() async {
    try {
      PhotoMemo p = state.photoMemoList[delIndex];
      await FirebaseController.deletePhotoMemo(p);
      state.render(() {
        state.photoMemoList.removeAt(delIndex);
        delIndex = null;
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed to delete picture',
        content: '$e',
      );
    }
  }

  void saveSearchKeyString(String value) {
    keyString = value;
  }

  void search() async {
    state.formKey.currentState.save();
    var keys = keyString.split(',').toList();
    List<String> searchKeys = [];
    for (var k in keys) {
      if (k.trim().isNotEmpty) searchKeys.add(k.trim().toLowerCase());
    }

    try {
      List<PhotoMemo> results;
      if (searchKeys.isNotEmpty) {
        results = await FirebaseController.searchImage(
          createdBy: state.user.email,
          searchLabels: searchKeys,
        );
      } else {
        results =
            await FirebaseController.getPhotoMemoList(email: state.user.email);
      }
      state.render(() => state.photoMemoList = results);
    } catch (e) {
      print(e);
      MyDialog.info(
        context: state.context,
        title: 'Search error',
        content: '$e',
      );
    }
  }
}
