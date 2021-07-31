import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:drishti/src/cash_recognition/models/note_model.dart';

/// A singleton DatabaseHelper class
class DatabaseHelper {
  static final _dbName = "drishti.db";
  static final _dbVersion = 1;

  static const NOTES_TABLE_NAME = Note.TABLE_NAME;
  static const NOTES_COLUMN_ID = Note.COLUMN_ID;
  static const NOTES_COLUMN_NOTE = Note.COLUMN_NOTE;
  static const NOTES_COLUMN_DATETIME = Note.COLUMN_DATETIME;

  // making it a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _createDb);
  }

  /// create a database table for Cash Recognition
  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $NOTES_TABLE_NAME (
      $NOTES_COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $NOTES_COLUMN_NOTE INTEGER NOT NULL,
      $NOTES_COLUMN_DATETIME INTEGER NOT NULL
      )
      ''');
  }

  Future<int> insert(Note note) async {
    /// Insert given cash note object to db
    Database db = await (instance.database);
    note.datetimeInt = DateTime.now().microsecondsSinceEpoch;
    return await db.insert(NOTES_TABLE_NAME, note.toMap());
  }

  Future<List<Note>> queryToday() async {
    /// List notes inserted for the current day
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var tomorrow = today.add(Duration(days: 1));
    return queryCustom(today, tomorrow);
  }

  Future<List<Note>> queryWeek() async {
    /// List notes inserted for the current week
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var recentSunday = today.subtract(Duration(days: today.weekday % 7));
    var nextSunday = recentSunday.add(Duration(days: 7));
    return queryCustom(recentSunday, nextSunday);
  }

  Future<List<Note>> queryMonth() async {
    /// List notes inserted for the current month
    var now = DateTime.now();
    var firstMonthDay = DateTime(now.year, now.month, 1);
    var nextMonthDay = DateTime(now.year, now.month + 1, 1);
    return queryCustom(firstMonthDay, nextMonthDay);
  }

  Future<List<Note>> queryCustomDay(DateTime date) async {
    /// List notes inserted on a given day
    var day = DateTime(date.year, date.month, date.day);
    var nextDay = day.add(Duration(days: 1));
    return queryCustom(day, nextDay);
  }

  Future<List<Note>> queryCustom(
      DateTime initialDateTime, DateTime finalDateTime) async {
    /// List notes inserted from [initialDateTime] to [finalDateTime]
    Database db = await (instance.database);
    var notes = await db.query(NOTES_TABLE_NAME,
        where:
            "$NOTES_COLUMN_DATETIME BETWEEN '?' AND '?' ORDER BY $NOTES_COLUMN_DATETIME DESC",
        whereArgs: [
          initialDateTime.microsecondsSinceEpoch,
          finalDateTime.microsecondsSinceEpoch - 1
        ]);
    List<Note> noteList = [];
    notes.forEach((currentNote) {
      Note note = Note.fromMap(currentNote);
      noteList.add(note);
    });
    return noteList;
  }

  Future<List<Note>> queryAll() async {
    /// List all the notes stored in db
    Database db = await (instance.database);
    var notes = await db.query(NOTES_TABLE_NAME);
    List<Note> noteList = [];
    notes.forEach((currentNote) {
      Note note = Note.fromMap(currentNote);
      noteList.add(note);
    });
    return noteList;
  }

  Future<int> delete(int? id) async {
    /// Delete note with the given [id]
    Database db = await (instance.database);
    return await db.delete(NOTES_TABLE_NAME,
        where: '$NOTES_COLUMN_ID = ?', whereArgs: [id]);
  }
}
