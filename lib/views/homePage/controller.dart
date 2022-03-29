import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_note_app/views/states.dart';

import 'model.dart';

class NoteController extends Cubit<NoteStates> {
  NoteController() : super(InitialNoteState());

  static NoteController of(context) => BlocProvider.of(context);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController noteIdController = TextEditingController();

  addNote(context) {
    Note note = Note(
      noteId: noteIdController.text,
      title: titleController.text,
      content: contentController.text,
    );
    print('***************************');
    insertNote(note: note);
    print('***************************');

    titleController.clear();
    contentController.clear();
    noteIdController.clear();
    print('cleaaaaaaaaaaaar fields');
    Navigator.pop(context);
  }

  List<Note>? notes = [];

  Database? database;

  createDB() async {
    database = await openDatabase(
      'notes1.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE Notes (id INTEGER PRIMARY KEY, noteId TEXT, title TEXT, content TEXT)')
            .then((value) {
          print('create table success');
          print('========================================');
        });
      },
      onOpen: (db) {
        print('database opened');
        print('========================================');

        getAllNotes(db);
        print('All Notes shown');

        print('========================================');
      },
    );
  }

  insertNote({Note? note}) async {
    await database!.transaction((txn) async {
      database!.rawQuery(
        'INSERT INTO Notes(title, content, noteId) VALUES("${note!.title}","${note.content}","${note.noteId}")',
      );
    }).then((value) {
      getAllNotes(database!);
      print('note inserted successfully');
      print('========================================');
    }).catchError((e) {
      print(e);
    });
  }

  void getAllNotes(Database db) async {
    if (notes != null) {
      notes!.clear();
    }
    db.rawQuery('SELECT * FROM Notes').then((value) {
      value.forEach((element) {
        notes!.add(Note.fromJsom(element));
        print('get notes succeed');
        emit(GetAllNoteState());

        print('========================================');
      });
    }).catchError((e, s) {
      print(e);
      print(s);
    });
    // emit(GetAllNoteState());
  }

  deleteNote({noteId}) {
    database!
        .rawDelete('DELETE FROM Notes WHERE noteId = ?', [noteId]).then((value) {
      getAllNotes(database!);
      emit(DeleteNoteState());
      print('+++++++++++++++++++++++++++++++++++');
      print('deleted');
    }).catchError((e, s) {
      print(e);
      print(s);
    });
  }

  editNote(Note? note) {
    database!.rawUpdate(
        'UPDATE Notes SET title = ?, content = ? WHERE noteId = ?',
        [note!.title, note.content, note.noteId]).then((value) {
      getAllNotes(database!);
      emit(EditNoteState());
    });
  }
}
