class Note {
  int? id;
  String? noteId;

  String? title;
  String? content;

  Note({
    this.noteId,
    this.content,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'title': title,
      'content': content,
    };
  }

  Note.fromJsom(Map<String, dynamic> map) {
    id = map['id'];
    noteId = map['noteId'];
    title = map['title'];
    content = map['content'];
  }
}
