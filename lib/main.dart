import 'package:cmsc4303_lesson3/provider/reference.dart';
import 'package:cmsc4303_lesson3/screen/feed_screen.dart';
import 'package:cmsc4303_lesson3/screen/shared_with_comments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './model/constant.dart';
import './screen/addphotomeno_screen.dart';
import './screen/detailedview_screen.dart';
import './screen/shared_with_screen.dart';
import './screen/signin_screen.dart';
import './screen/signup_screen.dart';
import './screen/user_home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(Lesson3());
}

class Lesson3 extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: Constant.DEV,
  //     theme: ThemeData(
  //       brightness: Brightness.dark,
  //       primaryColor: Colors.amber,
  //       primarySwatch: Colors.blue,
  //       accentColor: Colors.blue,
  //     ),
  //     initialRoute: SignInScreen.routeName,
  //     routes: {
  //       SignInScreen.routeName: (context) => SignInScreen(),
  //       SignUpScreen.routeName: (context) => SignUpScreen(),
  //       UserHomeScreen.routeName: (context) => UserHomeScreen(),
  //       AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
  //       DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
  //       SharedWithScreen.routeName: (context) => SharedWithScreen(),
  //       SharedWithComments.routeName: (context) => SharedWithComments(),
  //       FeedScreen.routeName: (context) => FeedScreen(),
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ReferencesProvider(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FlutterChat',
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.amber,
                primarySwatch: Colors.blue,
                accentColor: Colors.blue,
              ),
              home: appSnapshot.connectionState != ConnectionState.done
                  ? CircularProgressIndicator()
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (userSnapshot.hasData) {
                          return FeedScreen();
                        }
                        return SignInScreen();
                      }),
              routes: {
                SignInScreen.routeName: (context) => SignInScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                UserHomeScreen.routeName: (context) => UserHomeScreen(),
                AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
                DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
                SharedWithScreen.routeName: (context) => SharedWithScreen(),
                SharedWithComments.routeName: (context) => SharedWithComments(),
                FeedScreen.routeName: (context) => FeedScreen(),
              },
            ),
          );
        });
  }
}
