import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteModel {
  String title;
  String body;
  Color noteColor;
  int isArchived = 0;

  NoteModel(this.title, this.body, this.noteColor);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> myNote = {};
    myNote['title'] = this.title;
    myNote['body'] = this.body;
    myNote['noteColor'] = this.noteColor.value;
    myNote['isArchived'] = this.isArchived;
    // print(myNote);
    return myNote;
  }
}

class NoteProvider {
  static Database db;

  static Future init() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'mynotes837.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute('''
        create table Notes(
          id integer primary key autoincrement,
          title text,
          body text,
          noteColor integer,
          isArchived integer
        )''');
      },
    );
  }

  static Future deleteDb() async {
    await deleteDatabase(
      join(await getDatabasesPath(), 'mynotes837.db'),
    );
    db = null;
  }

  static Future<List<Map<dynamic, dynamic>>> getNotes() async {
    if (db == null) {
      await init();
    }
    return await db.query('Notes');
  }

  static Future<void> insert(Map<dynamic, dynamic> note) async {
    // print(db);
    if (db == null) {
      await init();
    }
    // print(db);
    // print('Was here');
    await db.insert(
      'Notes',
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return;
  }

  static Future<void> update(Map<dynamic, dynamic> note) async {
    if (db == null) {
      await init();
    }
    await db.update(
      'Notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
    return;
  }

  static Future<void> delete(int id) async {
    if (db == null) {
      await init();
    }
    await db.delete(
      'Notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
