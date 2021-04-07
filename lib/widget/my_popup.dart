import 'package:flutter/material.dart';

class MyPopup {
  static void info({
    @required BuildContext context,
    @required String title,
    @required List<String> content,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        scrollable: true,
        backgroundColor: Colors.grey[900],
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.height * 0.1,
          padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
          child: ListView.builder(
            itemCount: content.length,
            itemBuilder: (BuildContext context, int index) => Text(
              '${content[index]}',
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 12.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
