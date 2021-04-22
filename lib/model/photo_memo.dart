class PhotoMemo {
  String docId;
  String createdBy;
  String title;
  String memo;
  String photoFileName;
  String photoURL;
  bool isPublic;
  DateTime timestamp;
  List<dynamic> sharedWith; // list of email
  List<dynamic> imageLabels; // identify by ML

  // Key for Firestore doc
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'created_by';
  static const PHOTO_URL = 'photo_URL';
  static const PHOTO_FILENAME = 'photo_filename';
  static const TIMESTAMP = 'timestamp';
  static const SHARED_WITH = 'shared_with';
  static const IMAGE_LABELS = 'image_label';
  static const IS_PUBLIC = 'is_public';

  PhotoMemo(
      {this.docId,
      this.createdBy,
      this.memo,
      this.title,
      this.photoFileName,
      this.photoURL,
      this.timestamp,
      this.isPublic,
      this.sharedWith,
      this.imageLabels}) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
  }

  // From dart object to FireStore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: this.title,
      MEMO: this.memo,
      CREATED_BY: this.createdBy,
      PHOTO_URL: this.photoURL,
      PHOTO_FILENAME: this.photoFileName,
      TIMESTAMP: this.timestamp,
      IS_PUBLIC: this.isPublic,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLabels,
    };
  }

  static PhotoMemo deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY],
      memo: doc[MEMO],
      title: doc[TITLE],
      photoFileName: doc[PHOTO_FILENAME],
      photoURL: doc[PHOTO_URL],
      sharedWith: doc[SHARED_WITH],
      imageLabels: doc[IMAGE_LABELS],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch),
      isPublic: doc[IS_PUBLIC] ??= false,
    );
  }

  static String validateTitle(String value) {
    if (value == null || value.length < 3)
      return 'too short';
    else
      return null;
  }

  static String validateMemo(String value) {
    // if (value == null || value.length < 5)
    //   return 'too short';
    // else
      return null;
  }

  static String validateSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;
    List<String> emailList =
        value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'Comma(,) or space separated email list';
    }
    return null;
  }

  PhotoMemo.clone(PhotoMemo photoMemo) {
    this.docId = photoMemo.docId;
    this.createdBy = photoMemo.createdBy;
    this.memo = photoMemo.memo;
    this.title = photoMemo.title;
    this.photoFileName = photoMemo.photoFileName;
    this.photoURL = photoMemo.photoURL;
    this.timestamp = photoMemo.timestamp;
    this.isPublic = photoMemo.isPublic;

    this.sharedWith = [];
    this.sharedWith.addAll(photoMemo.sharedWith);
    this.imageLabels = [];
    this.imageLabels.addAll(photoMemo.imageLabels);
  }

  void assign(PhotoMemo photoMemo) {
    this.docId = photoMemo.docId;
    this.createdBy = photoMemo.createdBy;
    this.memo = photoMemo.memo;
    this.title = photoMemo.title;
    this.photoFileName = photoMemo.photoFileName;
    this.photoURL = photoMemo.photoURL;
    this.timestamp = photoMemo.timestamp;
    this.isPublic = photoMemo.isPublic;

    this.sharedWith.clear();
    this.sharedWith.addAll(photoMemo.sharedWith);
    this.imageLabels.clear();
    this.imageLabels.addAll(photoMemo.imageLabels);
  }
}
