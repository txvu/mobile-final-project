class PhotoComment {
  String docId;
  String createdBy;
  String photoURL;
  DateTime timestamp;
  String comments; // list of comments

  // Key for Firestore doc
  static const CREATED_BY = 'created_by';
  static const PHOTO_URL = 'photo_URL';
  static const TIMESTAMP = 'timestamp';
  static const COMMENTS = 'comments';

  PhotoComment({
    this.docId,
    this.createdBy,
    this.photoURL,
    this.timestamp,
    this.comments,
  }) {
    //this.comments ??= [];
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

  static PhotoComment deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoComment(
      docId: docId,
      createdBy: doc[CREATED_BY],
      photoURL: doc[PHOTO_URL],
      comments: doc[COMMENTS],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }

  static String validateComment(String value) {
    if (value == null || value.length < 2)
      return 'too short';
    else
      return null;
  }

  PhotoComment.clone(PhotoComment photoComment) {
    this.docId = photoComment.docId;
    this.createdBy = photoComment.createdBy;
    this.photoURL = photoComment.photoURL;
    this.timestamp = photoComment.timestamp;

    this.comments = photoComment.comments;
  }

  void assign(PhotoComment photoComment) {
    this.docId = photoComment.docId;
    this.createdBy = photoComment.createdBy;
    this.photoURL = photoComment.photoURL;
    this.timestamp = photoComment.timestamp;
    this.comments = photoComment.comments;
  }
}
