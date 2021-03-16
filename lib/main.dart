import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/screen/addphotomeno_screen.dart';
import 'package:cmsc4303_lesson3/screen/detailedview_screen.dart';
import 'package:cmsc4303_lesson3/screen/signin_screen.dart';
import 'package:cmsc4303_lesson3/screen/signup_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Lesson3());
}

class Lesson3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
        DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
      },
    );
  }
}
