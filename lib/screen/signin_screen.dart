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
        title: Text(''),
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

  void validateEmail() {

  }

  void saveEmail() {

  }
}
