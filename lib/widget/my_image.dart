import 'package:flutter/material.dart';

class MyImage {
  static Image network({@required String url, @required BuildContext context}) {
    return Image.network(
      url,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent loadingProgess) {
        if (loadingProgess == null) return child;
        return CircularProgressIndicator(
          value: loadingProgess.expectedTotalBytes != null
              ? loadingProgess.cumulativeBytesLoaded /
                  loadingProgess.expectedTotalBytes
              : null,
        );
      },
    );
  }
}
