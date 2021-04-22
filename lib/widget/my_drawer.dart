import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/screen/detailedview_screen.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'my_dialog.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<PhotoMemo> photoMemoList;
  User user = FirebaseAuth.instance.currentUser;
  _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: con.sharedWithMe,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async {
              try {
                await FirebaseController.signOut();
                Navigator.of(context).pushNamed(SignInScreen.routeName);
              } catch (e) {
                // do nothing
              }
              Navigator.of(context).pop();
              // Navigator.of(state.context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _MyDrawerState state;
  int delIndex;
  String keyString;

  _Controller(this.state);

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }
    Navigator.of(state.context).pushNamed(SignInScreen.routeName);
    // Navigator.of(state.context).pop();
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
          await FirebaseController.getPhotoMemoSharedWithMe(email: state.user.email);
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
}
