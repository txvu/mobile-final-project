import 'dart:io';

import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomemo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_screen.dart';
import 'package:cmsc4303_lesson3/model/photoComment.dart';

class SharedWithComments extends StatefulWidget {
  static const routeName = '/sharedWithCommentsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SharedWithCommentsState();
  }
}

class _SharedWithCommentsState extends State<SharedWithComments> {
  _Controller controller;
  GlobalKey<FormState> formKey = GlobalKey();
  PhotoMemo onePhotoMemoTemp;
  String photoUrl;
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    photoUrl ??= args[Constant.ARG_ONE_PHOTOMEMO];
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        key: formKey,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .4,
              child: MyImage.network(
                url: photoUrl,
                context: context,
              ),
            ),
            TextFormField(
              controller: myController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Enter a Comment'),
            ),
            ElevatedButton(
              onPressed: () {
                print(myController.text);
              },
              child: Text('Post Message'),
              style: ElevatedButton.styleFrom(primary: Colors.amber, elevation: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _SharedWithCommentsState state;
  _Controller(this.state);
  PhotoComments photoComments = PhotoComments();

  void saveComment(String value) {
    photoComments.comments.add(value);
  }
}
