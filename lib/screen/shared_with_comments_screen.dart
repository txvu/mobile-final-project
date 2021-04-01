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
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: MyImage.network(
                    url: photoUrl,
                    context: context,
                  ),
                ),
                // controller.comments.length > 0
                //     ? Container(
                //         height: MediaQuery.of(context).size.height * 0.4,
                //         padding: EdgeInsets.all(8.0),
                //         child: ListView.builder(
                //           itemCount: controller.comments.length,
                //           itemBuilder: (BuildContext context, int index) =>
                //               Container(
                //             color: Colors.white10,
                //             margin: EdgeInsets.only(bottom: 5.0),
                //             child: ListTile(
                //               title: Text(controller.comments[index].comments),
                //               subtitle:
                //                   Text(controller.comments[index].createdBy),
                //             ),
                //           ),
                //         ),
                //       )
                //     : Text('No comment'),
                FutureBuilder(
                  future: controller.getMessages(photoUrl),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              color: Colors.white10,
                              margin: EdgeInsets.only(bottom: 5.0),
                              child: ListTile(
                                title:
                                    Text(snapshot.data[index].comments),
                                subtitle:
                                    Text(snapshot.data[index].createdBy),
                              ),
                            ),
                          ));
                    } else {
                      return Text('No Comment');
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter a Comment'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(myController.text);
                      controller.saveComment(myController.text, photoUrl);
                      controller.displayMessage();
                    },
                    child: Text(
                      'Post Message',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber, elevation: 10),
                  ),
                  SizedBox(
                    height: 8.0,
                  )
                ],
              ),
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


  Future<void> saveComment(String value, photoURL) async {
    photoComments.photoURL = photoURL;
    photoComments.comments = value;
    photoComments.timestamp = DateTime.now();
    photoComments.createdBy = state.user.email;
    String tempDocId = await FirebaseController.addPhotoComment(photoComments);
    photoComments.docId = tempDocId;
  }

  Future<List<PhotoComments>> getMessages(String URL) async {
    List<PhotoComments> comments = [];
    comments = await FirebaseController.getPhotoComments(photoURL: URL);
    print('im here2222n----> ${comments.length}');

    for (int i = 0; i < comments.length; i++) {
      //thisPhotoComment.add(comments[i].comments);
      //thisPhotoCommentEmail.add(comments[i].createdBy.toString());

      print(comments[i].comments.toString());
    }
    return comments;
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
