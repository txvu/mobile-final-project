import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReferencesProvider extends ChangeNotifier {
  final _user = FirebaseAuth.instance.currentUser;

}