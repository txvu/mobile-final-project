import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_comment.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseController {
  static Future<User> signIn({@required String email, @required String password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  static Future<void> createNewAccount(
      {@required String email, @required String password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<Map<String, String>> uploadPhotoFile({
    @required File photo,
    String fileName,
    @required String uid,
    @required Function listener,
  }) async {
    fileName ??= '${Constant.PHOTO_IMAGE_FOLDER}/$uid/${DateTime.now()}';
    UploadTask task = FirebaseStorage.instance.ref(fileName).putFile(photo);
    task.snapshotEvents.listen((TaskSnapshot event) {
      double progress = event.bytesTransferred / event.totalBytes;
      if (event.bytesTransferred == event.totalBytes) progress = null;
      listener(progress);
      // listener(progress);
    });
    await task;
    String downloadURL = await FirebaseStorage.instance.ref(fileName).getDownloadURL();
    return <String, String>{
      Constant.ARG_DOWNLOAD_URL: downloadURL,
      Constant.ARG_FILE_NAME: fileName,
    };
  }

  static Future<String> addPhotoMemo(PhotoMemo photoMemo) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .add(photoMemo.serialize());
    return ref.id;
  }

  static Future<String> addPhotoComment(PhotoComment photoComments) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_COMMENTS)
        .add(photoComments.serialize());
    return ref.id;
  }

  static Future<List<PhotoMemo>> getPhotoMemoList({@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });
    return result;
  }

  static Future<List<PhotoComment>> getPhotoComments({@required String photoURL}) async {
    print('Fetching comments...');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_COMMENTS)
        .where(PhotoComment.PHOTO_URL, isEqualTo: photoURL)
        .orderBy(PhotoComment.TIMESTAMP, descending: true)
        .get();

    print('Fetched comments...');
    var result = <PhotoComment>[];
    querySnapshot.docs.forEach((doc) {
      print('adding comment...');

      result.add(PhotoComment.deserialize(doc.data(), doc.id));
      print('aded comment...');
    });

    return result;
  }

  static Future<List<dynamic>> getImageLabelsWithImageLabeler({@required File photoFile}) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(photoFile);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);
    List<dynamic> labels = <dynamic>[];
    for (ImageLabel label in cloudLabels) {
      if (label.confidence >= Constant.MIN_ML_CONFIDENCE) {
        labels.add(label.text.toLowerCase());
      }
    }
    return labels;
  }


  static Future<List<dynamic>> getImageLabelsWithTextRecognizer({@required File photoFile}) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(photoFile);
    final TextRecognizer cloudTextRecognizer = FirebaseVision.instance.cloudTextRecognizer();
    final VisionText visionText = await cloudTextRecognizer.processImage(visionImage);
    List<dynamic> labels = <dynamic>[];
    labels.add(visionText.text.toLowerCase());
    // List<dynamic> list = visionText.text.split(RegExp('(,| \n)+')).map((e) => e.trim().replaceAll('\n', ' ').toLowerCase()).toList();
    // for (String label in list) {
    //     labels.add(label.toLowerCase());
    // }
    // print('vision text: ${visionText.text.replaceAll('\n', ' ')}');
    return labels;
  }

  static Future<void> updatePhotoFile(
    String docId,
    Map<String, dynamic> updateInfo,
  ) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<List<PhotoMemo>> getPhotoMemoSharedWithMe(
      {@required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .where(PhotoMemo.SHARED_WITH, arrayContains: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      result.add(PhotoMemo.deserialize(doc.data(), doc.id));
    });

    return result;
  }

  static Future<void> deletePhotoMemo(PhotoMemo photoMemo) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .doc(photoMemo.docId)
        .delete();

    await FirebaseStorage.instance.ref().child(photoMemo.photoFileName).delete();
  }

  static Future<List<PhotoMemo>> searchImage(
      {@required String createdBy, @required List<String> searchLabels}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTO_MEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: createdBy)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();

    var result = <PhotoMemo>[];
    querySnapshot.docs
        .forEach((doc) => result.add(PhotoMemo.deserialize(doc.data(), doc.id)));

    return result;
  }
}
