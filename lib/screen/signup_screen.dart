import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:cmsc4303_lesson3/screen/myview/my_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Create an account',
                  style: Theme.of(context).textTheme.headline5,
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
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: controller.validatePassword,
                  onSaved: controller.savePassword,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password Confirm',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: controller.validatePassword,
                  onSaved: controller.savePasswordConfirm,
                ),
                controller.passwordErrorMessage == null
                    ? SizedBox(
                        height: 15.0,
                      )
                    : Text(
                        controller.passwordErrorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                ElevatedButton(
                  child: Text(
                    'Create',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: controller.createAccount,
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
  _SignUpScreenState state;

  _Controller(this.state);

  String email;
  String password;
  String passwordConfirm;
  String passwordErrorMessage;

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

  void savePasswordConfirm(String value) {
    passwordConfirm = value;
  }

  void createAccount() async {
    if (!state.formKey.currentState.validate()) return;

    state.render(() => passwordErrorMessage = null);

    state.formKey.currentState.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = 'Password do not match');
      return;
    }

    // MyDialog.circularProgressStart(state.context);

    try {
      await FirebaseController.createNewAccount(email: email, password: password);

      MyDialog.info(
        context: state.context,
        title: 'Account created!',
        content: 'Go to Sign In to use the app',
      );
    } catch (e) {
      print(e);
      // MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Cannot create',
        content: e.toString(),
      );
      return;
    }
  }
}
