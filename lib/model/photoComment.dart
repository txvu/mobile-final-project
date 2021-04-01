class PhotoComments {
  String docId;
  String createdBy;
  String photoURL;
  DateTime timestamp;
  List<dynamic> comments; // list of comments

  // Key for Firestore doc
  static const CREATED_BY = 'created_by';
  static const PHOTO_URL = 'photo_URL';
  static const TIMESTAMP = 'timestamp';
  static const COMMENTS = 'comments';

  PhotoComments({
    this.docId,
    this.createdBy,
    this.photoURL,
    this.timestamp,
    this.comments,
  }) {
    this.comments ??= [];
  }

  // From dart object to FireStore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: this.createdBy,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      COMMENTS: this.comments,
    };
  }

  static PhotoComments deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoComments(
      docId: docId,
      createdBy: doc[CREATED_BY],
      photoURL: doc[PHOTO_URL],
      comments: doc[COMMENTS],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }

  PhotoComments.clone(PhotoComments photoMemo) {
    this.docId = photoMemo.docId;
    this.createdBy = photoMemo.createdBy;
    this.photoURL = photoMemo.photoURL;
    this.timestamp = photoMemo.timestamp;

    this.comments = [];
    this.comments.addAll(photoMemo.comments);
  }

  void assign(PhotoComments photoMemo) {
    this.docId = photoMemo.docId;
    this.createdBy = photoMemo.createdBy;
    this.photoURL = photoMemo.photoURL;
    this.timestamp = photoMemo.timestamp;

    this.comments.clear();
    this.comments.addAll(photoMemo.comments);
  }
}
