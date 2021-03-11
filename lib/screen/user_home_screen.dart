import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomeno.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
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
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    return WillPopScope(
      onWillPop: () => Future.value(false), // Disable android back button
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Home'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user.displayName ?? 'N/A'),
                accountEmail: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: controller.signOut,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.addButton,
        ),
        body: photoMemoList.length == 0
            ? Text(
                'No PhotoMemo Found!',
                style: Theme.of(context).textTheme.headline5,
              )
            : ListView.builder(
                itemCount: photoMemoList.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: MyImage.network(
                    url: photoMemoList[index].photoURL,
                    context: context,
                  ),
                  title: Text(photoMemoList[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        photoMemoList[index].memo.length >= 20
                            ? photoMemoList[index].memo.substring(0, 20) + '...'
                            : photoMemoList[index].memo,
                      ),
                      Text('created By:  ${photoMemoList[index].createdBy}'),
                      Text('Shared With: ${photoMemoList[index].sharedWith}'),
                      Text('Updated At: ${photoMemoList[index].timestamp}'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _Controller {
  _UserHomeScreenState state;

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
    state.render(() {}); // render the scrren
  }
}
