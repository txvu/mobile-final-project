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
      ),
      body: Text(user.email),
    );
  }
}

class _Controller {
  _AddPhotoMemoScreenState state;
  _Controller(this.state);
}
