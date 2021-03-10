import 'package:cmsc4303_lesson3/screen/signin_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Lesson3());
}

class Lesson3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
      },
    );
  }
}
