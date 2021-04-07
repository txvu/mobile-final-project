import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_comment.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/widget/my_dialog.dart';
import 'package:cmsc4303_lesson3/widget/my_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final PhotoMemo photoMemo;

  CommentWidget(this.photoMemo);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
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
    PhotoMemo _photoMemo = widget.photoMemo;
    print('Start to get commetns');
    controller.getMessages(photoUrl);

    // Map args = ModalRoute.of(context).settings.arguments;
    photoUrl ??= _photoMemo.photoURL;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              'Comments',
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.normal),
            ),
          ),
          FutureBuilder(
            future: controller.getMessages(photoUrl),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    height: snapshot.data.length > 0 ? MediaQuery.of(context).size.height * 0.2 : 1,
                    padding: EdgeInsets.only(right: 10.0,left: 10.0, bottom: 5.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        // color: Colors.white10,
                        // margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                        Text(
                            '${snapshot.data[index].createdBy} ',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              snapshot.data[index].comments,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ));
              } else {
                return Text('No Comment');
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  height: 45.0,
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      // labelText: 'Enter a Comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          print(myController.text);
                          controller.saveComment(
                              myController.text.toString(), photoUrl);
                          controller.displayMessage();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _CommentWidgetState state;

  _Controller(this.state);

  PhotoComment photoComments = PhotoComment();
  List<String> thisPhotoComment = []; // list of comments
  List<String> thisPhotoCommentEmail = []; // list of comments

  Future<void> saveComment(String value, photoURL) async {
    if (value == null || value.length < 2) {
      print('value length =' + value.length.toString());
      MyDialog.info(
        context: state.context,
        title: 'Invalid comment',
        content: 'comment too short',
      );
    } else {
      print("Got here value is good!!!");
      photoComments.photoURL = photoURL;
      photoComments.comments = value;
      photoComments.timestamp = DateTime.now();
      photoComments.createdBy = state.user.email;
      String tempDocId =
          await FirebaseController.addPhotoComment(photoComments);
      photoComments.docId = tempDocId;
      state.render(() {
        state.myController.text = '';
      });
    }
  }

  Future<List<PhotoComment>> getMessages(String URL) async {
    List<PhotoComment> comments = [];
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
