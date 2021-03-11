import 'dart:io';

import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomeno.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPhotoMemoScreen extends StatefulWidget {
  static const routeName = '/addphotomeno_screen';

  @override
  _AddPhotoMemoScreenState createState() => _AddPhotoMemoScreenState();
}

class _AddPhotoMemoScreenState extends State<AddPhotoMemoScreen> {
  _Controller controller;
  User user = FirebaseAuth.instance.currentUser;
  GlobalKey<FormState> formKey = GlobalKey();
  File photo;

  @override
  void initState() {
    super.initState();
    controller = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PhotoMemo'),
        actions: [
          IconButton(icon: Icon(Icons.check), onPressed: controller.save),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: photo == null
                        ? Icon(Icons.photo_library, size: 300)
                        : Image.file(
                            photo,
                            fit: BoxFit.fill,
                          ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      color: Colors.blue[200],
                      child: PopupMenuButton<String>(
                        onSelected: controller.getPhoto,
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.photo_camera),
                                Text(Constant.SRC_CAMERA),
                              ],
                            ),
                            value: Constant.SRC_CAMERA,
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.photo_album),
                                Text(Constant.SRC_GALLERY),
                              ],
                            ),
                            value: Constant.SRC_GALLERY,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                autocorrect: true,
                validator: PhotoMemo.validateTitle,
                onSaved: controller.saveTitle,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Memo',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                autocorrect: true,
                validator: PhotoMemo.validateMemo,
                onSaved: controller.saveMemo,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Shared With (comma separated email list)',
                ),
                keyboardType: TextInputType.emailAddress,
                maxLines: 2,
                validator: PhotoMemo.validateSharedWith,
                onSaved: controller.saveSharedWith,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddPhotoMemoScreenState state;

  _Controller(this.state);

  PhotoMemo tempMemo = PhotoMemo();

  void save() {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();
  }

  void saveTitle(String value) {
    tempMemo.title = value;
  }

  void saveMemo(String value) {
    tempMemo.memo = value;
  }

  void saveSharedWith(String value) {
    if (value.trim().length != 0) {
      tempMemo.sharedWith =
          value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    }
  }

  void getPhoto(String src) {

  }
}
