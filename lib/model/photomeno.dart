class PhotoMemo {
  String docId;
  String createdBy;
  String title;
  String memo;
  String photoFileName;
  String photoURL;
  DateTime timestamp;
  List<dynamic> sharedWith; // list of email
  List<dynamic> imageLabels; // identify by ML

  PhotoMemo(
      {this.docId,
      this.createdBy,
      this.memo,
      this.title,
      this.photoFileName,
      this.photoURL,
      this.timestamp,
        this.sharedWith,
      this.imageLabels}) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
  }

  static String validateTitle(String value) {
    if (value == null || value.length < 3) return 'too short';
    else return null;
  }

  static String validateMemo(String value) {
    if (value == null || value.length < 5) return 'too short';
    else return null;
  }

  static String validateSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;
    List<String> emailList = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.')) continue;
      else return 'Comma(,) or space separated email list';
    }
    return null;
  }

}
