class PhotoLike {
  String docId;
  String createdBy;
  String photoURL;
  DateTime timestamp;

  // Key for Firestore doc
  static const CREATED_BY = 'created_by';
  static const PHOTO_URL = 'photo_URL';
  static const TIMESTAMP = 'timestamp';

  PhotoLike({
    this.docId,
    this.createdBy,
    this.photoURL,
    this.timestamp,
  }) {
    //this.comments ??= [];
  }

  // From dart object to FireStore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: this.createdBy,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
    };
  }

  static PhotoLike deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoLike(
      docId: docId,
      createdBy: doc[CREATED_BY],
      photoURL: doc[PHOTO_URL],
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

  PhotoLike.clone(PhotoLike photoLike) {
    this.docId = photoLike.docId;
    this.createdBy = photoLike.createdBy;
    this.photoURL = photoLike.photoURL;
    this.timestamp = photoLike.timestamp;
  }

  void assign(PhotoLike photoLike) {
    this.docId = photoLike.docId;
    this.createdBy = photoLike.createdBy;
    this.photoURL = photoLike.photoURL;
    this.timestamp = photoLike.timestamp;
  }
}
