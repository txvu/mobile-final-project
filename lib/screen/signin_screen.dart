import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              ElevatedButton(
                child: Text('Sign In', style: Theme.of(context).textTheme.button,),
                onPressed: controller.signIn,
              )
            ],
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
    if (value.contains('@') && value.contains('.')) return null;
    else return 'Invalid email address';
  }
  String validatePassword(String value) {
    if (value.length < 6) return 'Too short';
    else return null;
  }

  void saveEmail(String value) {
    email = value;
  }
  void savePassword(String value) {
    password = value;
  }

  void signIn() async {
    if (!state.formKey.currentState.validate()) return ;

    state.formKey.currentState.save();

    User user;

    try {
      user = await FirebaseController.signIn(email: email, password: password);
      print('user::: ${user.email} ::: ${user.metadata}');
    } catch (e) {

    }
  }
}
