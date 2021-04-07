import 'package:cmsc4303_lesson3/controller/firebase_controller.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Icon(Icons.person, size: 100.0),
            // accountName: Text(user.displayName ?? 'N/A'),
            // accountEmail: Text(user.email),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Shared With Me'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async {
              try {
                await FirebaseController.signOut();
              } catch (e) {
                // do nothing
              }
              Navigator.of(context).pop();
              // Navigator.of(state.context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
