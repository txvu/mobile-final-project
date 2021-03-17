import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomemo.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    user ??= args[Constant.ARG_USER];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shared With Me'),
      ),
      body: photoMemoList.length == 0
          ? Text(
              'No PhotoMemos shared with me.',
              style: Theme.of(context).textTheme.headline5,
            )
          : ListView.builder(
              itemCount: photoMemoList.length,
              itemBuilder: (context, index) => Card(
                elevation: 7.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: MyImage.network(
                          url: photoMemoList[index].photoURL,
                          context: context,
                        ),
                      ),
                    ),
                    Text(
                      'Title: ${photoMemoList[index].title}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Memo: ${photoMemoList[index].memo}',
                      // style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Created By: ${photoMemoList[index].createdBy}',
                      // style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Updated At: ${photoMemoList[index].timestamp}',
                      // style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Shared With: ${photoMemoList[index].sharedWith}',
                      // style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _SharedWithScreenState state;

  _Controller(this.state);
}
