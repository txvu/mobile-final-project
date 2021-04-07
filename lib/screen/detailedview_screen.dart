import 'dart:io';

import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photo_memo.dart';
import 'package:image_picker/image_picker.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';

  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  _Controller controller;
  User user;
  PhotoMemo onePhotoMemoOriginal;
  PhotoMemo onePhotoMemoTemp;
  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey();
  String progressMessage;

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
    onePhotoMemoOriginal ??= args[Constant.ARG_ONE_PHOTOMEMO];
    onePhotoMemoTemp ??= PhotoMemo.clone(onePhotoMemoOriginal);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed View'),
        actions: [
          editMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: controller.update,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: controller.edit,
                ),
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
                    child: controller.photoFile == null
                        ? MyImage.network(
                            url: onePhotoMemoTemp.photoURL,
                            context: context,
                          )
                        : Image.file(
                            controller.photoFile,
                            fit: BoxFit.fill,
                          ),
                  ),
                  editMode
                      ? Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            color: Colors.blue,
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
                        )
                      : SizedBox(height: 1.0),
                ],
              ),
              progressMessage == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      progressMessage,
                      style: Theme.of(context).textTheme.headline6,
                    ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                ),
                initialValue: onePhotoMemoTemp.title,
                autocorrect: true,
                validator: PhotoMemo.validateTitle,
                onSaved: controller.saveTitle,
              ),
              TextFormField(
                enabled: editMode,
                // style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter memo',
                ),
                initialValue: onePhotoMemoTemp.memo,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                autocorrect: true,
                validator: PhotoMemo.validateMemo,
                onSaved: controller.saveMemo,
              ),
              TextFormField(
                enabled: editMode,
                // style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter share with (email list)',
                ),
                initialValue: onePhotoMemoTemp.sharedWith.join(', '),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                autocorrect: false,
                validator: PhotoMemo.validateSharedWith,
                onSaved: controller.saveSharedWith,
              ),
              SizedBox(
                height: 5.0,
              ),
              Constant.DEV
                  ? Text(
                      'Image labels generated by ML',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(
                      height: 1.0,
                    ),
              Constant.DEV
                  ? Text(onePhotoMemoTemp.imageLabels.join(' | '))
                  : SizedBox(
                      height: 1.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _DetailedViewState state;

  _Controller(this.state);

  File photoFile;

  void update() async {
    // state.render(() => state.editMode = false);
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};

      if (photoFile != null) {
        Map photoInfo = await FirebaseController.uploadPhotoFile(
          photo: photoFile,
          fileName: state.onePhotoMemoTemp.photoFileName,
          uid: state.user.uid,
          listener: (double progress) {
            state.render(() {
              if (progress == null)
                state.progressMessage = null;
              else {
                progress *= 100;
                state.progressMessage = 'Uploading ' + progress.toStringAsFixed(1) + '%';
              }
            });
          },
        );

        // image labels by ML
        state.onePhotoMemoTemp.photoURL = photoInfo[Constant.ARG_DOWNLOAD_URL];
        state.render(() => state.progressMessage = 'ML Image Labeler Started!');
        List<dynamic> imageLabels = await FirebaseController.getImageLabels(photoFile: photoFile);
        state.onePhotoMemoTemp.imageLabels = imageLabels;
        state.render(() => state.progressMessage = null);

        // updateInfo[PhotoMemo.PHOTO_URL] = updateInfo[Constant.ARG_FILE_NAME];
        updateInfo[PhotoMemo.PHOTO_URL] = photoInfo[Constant.ARG_DOWNLOAD_URL];
        updateInfo[PhotoMemo.IMAGE_LABELS] = imageLabels;
      }

      if (state.onePhotoMemoOriginal.title != state.onePhotoMemoTemp.title)
        updateInfo[PhotoMemo.TITLE] = state.onePhotoMemoTemp.title;

      if (state.onePhotoMemoOriginal.memo != state.onePhotoMemoTemp.memo)
        updateInfo[PhotoMemo.MEMO] = state.onePhotoMemoTemp.memo;

      if (!listEquals(state.onePhotoMemoOriginal.sharedWith, state.onePhotoMemoTemp.sharedWith))
        updateInfo[PhotoMemo.SHARED_WITH] = state.onePhotoMemoTemp.sharedWith;

      updateInfo[PhotoMemo.TIMESTAMP] = DateTime.now();

      await FirebaseController.updatePhotoFile(state.onePhotoMemoTemp.docId, updateInfo);

      state.onePhotoMemoOriginal.assign(state.onePhotoMemoTemp);

      MyDialog.circularProgressStop(state.context);

      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Save PhotoMemo Error',
        content: '$e',
      );
    }
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void getPhoto(String src) async {
    try {
      PickedFile _imageFile;
      var _picker = ImagePicker();
      if (src == Constant.SRC_CAMERA) {
        _imageFile = await _picker.getImage(source: ImageSource.camera);
      } else {
        _imageFile = await _picker.getImage(source: ImageSource.gallery);
      }
      if (_imageFile == null) return; // cancel when selecting
      state.render(() => photoFile = File(_imageFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed to get picture',
        content: '$e',
      );
    }
  }

  void saveTitle(String value) {
    state.onePhotoMemoTemp.title = value;
  }

  void saveMemo(String value) {
    state.onePhotoMemoTemp.memo = value;
  }

  void saveSharedWith(String value) {
    if (value.trim().length != 0) {
      state.onePhotoMemoTemp.sharedWith = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    }
  }
}
