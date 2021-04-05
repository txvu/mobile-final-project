import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/model/constant.dart';
import 'package:cmsc4303_lesson3/model/photomemo.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:cmsc4303_lesson3/screen/signup_screen.dart';
import 'package:cmsc4303_lesson3/screen/user_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin_screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  _Controller controller;
  GlobalKey<FormState> formKey = GlobalKey();

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
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'PhotoMemo',
                  style: TextStyle(fontFamily: 'Lobster', fontSize: 40.0),
                ),
                Text(
                  'Sign in, please!',
                  style: TextStyle(
                    fontFamily: 'Lobster',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: controller.validateEmail,
                  onSaved: controller.saveEmail,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                  autocorrect: false,
                  validator: controller.validatePassword,
                  onSaved: controller.savePassword,
                ),
                SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: controller.signIn,
                ),
                SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  child: Text(
                    'Create a new account',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: controller.signUp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInScreenState state;

  _Controller(this.state);

  String email;
  String password;

  String validateEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid email address';
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'Too short';
    else
      return null;
  }

  void saveEmail(String value) {
    email = value;
  }

  void savePassword(String value) {
    password = value;
  }

  void signIn() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();

    User user;

    // MyDialog.circularProgressStart(state.context);

    try {
      user = await FirebaseController.signIn(email: email, password: password);
      print('user::: ${user.email} ::: ${user.metadata}');
    } catch (e) {
      print(e);
      // MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Sign In Error',
        content: e.toString(),
      );
      return;
    }

    // try {
    //   List<PhotoMemo> photomemoList =
    //       await FirebaseController.getPhotoMemoList(email: user.email);
    //   MyDialog.circularProgressStop(state.context);
    //   Navigator.pushNamed(state.context, UserHomeScreen.routeName, arguments: {
    //     Constant.ARG_USER: user,
    //     Constant.ARG_PHOTOMEMOLIST: photomemoList,
    //   });
    //   print(photomemoList.length);
    // } catch (e) {
    //   MyDialog.circularProgressStop(state.context);
    //   MyDialog.info(
    //     context: state.context,
    //     title: 'Firestore getPhotomemolist Error',
    //     content: e.toString(),
    //   );
    //   print(e);
    // }
  }

  void signUp() {
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }
}
