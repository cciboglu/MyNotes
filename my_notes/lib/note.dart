import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Note {

  Note(this.id, this.headline, this.content, this.lastEdit, this.created);
  
  String id = "";
  String headline = "";
  String content = "";
  DateTime lastEdit = DateTime.now();
  DateTime created = DateTime.now();
  
  void setContent(TextEditingController controllerHeadline, TextEditingController controllerContent) async{
    headline= controllerHeadline.text;
    content = controllerContent.text;
    lastEdit = DateTime.now();
    Database database = await openDatabase(join(await getDatabasesPath(), 'database.db'));
    database.execute("UPDATE notes SET headline = ?, content = ?, lastEdit = ? WHERE id = ?", [headline, content, lastEdit.toString(), id]);
  }

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
        data["id"],
        data["headline"],
        data["content"],
        DateTime.parse(data["lastEdit"]),
        DateTime.parse(data["created"])
    );
  }

  static Future<void> createNote(Note note, List<Note> content) async{
    Database database = await openDatabase(join(await getDatabasesPath(), 'database.db'));
    database.execute("INSERT INTO notes (id, headline, content, lastEdit, created) VALUES (?, ?, ?, ?, ?)", [note.id, note.headline, note.content, note.lastEdit.toString(), note.created.toString()]);
    content.add(note);
  }

  static Future<void> removeNote(Note note, List<Note> content) async{
    Database database = await openDatabase(join(await getDatabasesPath(), 'database.db'));
    database.execute("DELETE FROM notes WHERE id = ?", [note.id]);
    content.remove(note);
  }

}