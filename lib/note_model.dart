class Note {
  String uid;
  String title;
  String desc;
  Note(this.uid,this.title, this.desc);
  static toMap (Note note){
    return {
      "uid": note.uid,
      "title": note.title,
      "desc": note.desc,
    };
  }
  factory Note.fromMap(Map<String, dynamic> map){
    return Note(map["uid"],map["title"], map["desc"]);

  }
}