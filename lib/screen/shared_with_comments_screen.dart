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
  User user = FirebaseAuth.instance.currentUser;
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
    print('Start to get commetns');
    controller.getMessages(photoUrl);

    Map args = ModalRoute.of(context).settings.arguments;
    photoUrl ??= args[Constant.ARG_ONE_PHOTOMEMO];

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: MyImage.network(
                    url: photoUrl,
                    context: context,
                  ),
                ),
                controller.comments.length > 0
                    ? SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.comments.length,
                          itemBuilder: (BuildContext context, int index) => ListTile(
                            title: Text(controller.comments[index].comments),
                          ),
                        ),
                      )
                    : SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Enter a Comment'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(myController.text);
                    controller.saveComment(myController.text, photoUrl);
                    controller.displayMessage();
                  },
                  child: Text('Post Comment'),
                  style: ElevatedButton.styleFrom(primary: Colors.amber, elevation: 10),
                ),
              ],
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
  List<String> thisPhotoComment = []; // list of comments
  List<String> thisPhotoCommentEmail = []; // list of comments
  List<PhotoComments> comments = [];

  Future<void> saveComment(String value, photoURL) async {
    photoComments.photoURL = photoURL;
    photoComments.comments = value;
    photoComments.timestamp = DateTime.now();
    photoComments.createdBy = state.user.email;
    String tempDocId = await FirebaseController.addPhotoComment(photoComments);
    photoComments.docId = tempDocId;
  }

  Future<void> getMessages(String URL) async {
    print('im here');
    comments = await FirebaseController.getPhotoComments(photoURL: URL);
    print('im here2222n----> ${comments.length}');

    for (int i = 0; i < comments.length; i++) {
      //thisPhotoComment.add(comments[i].comments);
      //thisPhotoCommentEmail.add(comments[i].createdBy.toString());

      print(comments[i].comments.toString());
    }
    print('im here3333');
  }

  displayMessage() {
    if (thisPhotoComment.isNotEmpty && thisPhotoCommentEmail.isNotEmpty) {
      for (int i = 0; i < thisPhotoComment.length; i++) {
        //Text(thisPhotoCommentEmail[i] + ": " + thisPhotoComment[i]);
        print('//////////////////////////////////////////////////////////////');
        print(thisPhotoCommentEmail[i] + ": " + thisPhotoComment[i]);
      }
    } else {
      return;
    }
  }
}
