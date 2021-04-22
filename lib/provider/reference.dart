import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Reference extends ChangeNotifier {
  final _user = FirebaseAuth.instance.currentUser;

  bool makePublic = false;
  bool enableImageLabeler = false;
  bool enableTextRecognizer = false;
}