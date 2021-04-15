import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_comment.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:cmsc4303_lesson3/widget/my_image.dart';
import 'package:cmsc4303_lesson3/widget/my_popup.dart';
import 'package:cmsc4303_lesson3/widget/comment_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhotoTile extends StatefulWidget {
  final PhotoMemo photoMemo;

  PhotoTile(this.photoMemo);

  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  bool _showComments = false;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    PhotoMemo _photoMemo = widget.photoMemo;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white30, width: 1.0),
        borderRadius: BorderRadius.circular(30.0),
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
                        'User:' + _photoMemo.createdBy.split('@')[0],
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _photoMemo.createdBy,
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
            // color: Colors.black,
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Center(
              child: MyImage.network(
                url: _photoMemo.photoURL,
                context: context,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: Text(
              _photoMemo.title,
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, right: 10.0, left: 10.0),
            child: Text(
              _photoMemo.memo.length >= 50
                  ? _photoMemo.memo.substring(0, 50) + '...'
                  : _photoMemo.memo,
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
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('photo_likes')
                              .where(PhotoComment.PHOTO_URL,
                                  isEqualTo: _photoMemo.photoURL)
                              .snapshots(),
                          builder: (ctx, commentsSnapshot) {
                            if (commentsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '.',
                                style: TextStyle(
                                    color: Colors.blue, fontWeight: FontWeight.bold),
                              );
                              ;
                            }
                            if (commentsSnapshot.hasData) {
                              final comments = commentsSnapshot.data.docs;

                              return Text(
                                comments.length.toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                            }
                            return Text('error');
                          }),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('photo_likes')
                            .where(PhotoComment.PHOTO_URL, isEqualTo: _photoMemo.photoURL)
                            .where('liked_by', isEqualTo: _user.email)
                            .snapshots(), // async work
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> likes = snapshot.data.docs;
                            if (likes.length > 0) {
                              return IconButton(
                                icon: Icon(
                                  Icons.thumb_up_alt,
                                  color: Colors.blue,
                                  size: 16.0,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('photo_likes')
                                      .doc(likes[0].id)
                                      .delete();
                                },
                              );
                            } else {
                              return IconButton(
                                icon: Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.blue,
                                  size: 16.0,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('photo_likes')
                                      .add({
                                    'liked_by': _user.email,
                                    'timestamp': DateTime.now(),
                                    'photo_URL': _photoMemo.photoURL,
                                  });
                                },
                              );
                            }
                          } else {
                            return Text('Its Error!');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(Constant.PHOTO_COMMENTS)
                              .where(PhotoComment.PHOTO_URL,
                                  isEqualTo: _photoMemo.photoURL)
                              .orderBy(PhotoComment.TIMESTAMP, descending: true)
                              .snapshots(),
                          builder: (ctx, commentsSnapshot) {
                            if (commentsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '.',
                                style: TextStyle(
                                    color: Colors.blue, fontWeight: FontWeight.normal),
                              );
                            }
                            if (commentsSnapshot.hasData) {
                              final comments = commentsSnapshot.data.docs;

                              return Text(
                                comments.length.toString(),
                                style: TextStyle(
                                    color: Colors.blue, fontWeight: FontWeight.normal),
                              );
                            }
                            return Text('error');
                          }),
                      IconButton(
                        icon: Icon(
                          Icons.insert_comment_outlined,
                          color: Colors.blue,
                          size: 16.0,
                        ),
                        onPressed: () {
                          setState(() {
                            _showComments = !_showComments;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Text(
                          _photoMemo.sharedWith.length.toString(),
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.normal),
                        ),
                        onTap: () {
                          MyPopup.info(
                              context: context,
                              title: 'Share',
                              content: _photoMemo.sharedWith
                                  .toString()
                                  .split(RegExp('(,| )+'))
                                  .map((e) => e.trim())
                                  .toList());
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                          color: Colors.blue,
                          size: 16.0,
                        ),
                        onPressed: () {
                          MyPopup.info(
                              context: context,
                              title: 'Shares',
                              content: _photoMemo.sharedWith
                                  .toString()
                                  .split(RegExp('(,| )+'))
                                  .map((e) => e.trim())
                                  .toList());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _showComments == false ? SizedBox(height: 1) : CommentWidget(_photoMemo),
        ],
      ),
    );
  }
}
