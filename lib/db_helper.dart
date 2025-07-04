import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  /// private constructor
  DbHelper._();
  /// singleton
  static DbHelper getInstance() => DbHelper._();
  //static DbHelper mInstance = DbHelper._();

  Database? mDB;

  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_ID = "n_id";
  static const String COLUMN_NOTE_TITLE = "n_title";
  static const String COLUMN_NOTE_DESC = "n_desc";
  static const String COLUMN_NOTE_CREATED_AT = "n_created_at";

  Future<Database> initDB() async{

    mDB ??= await openDB();

    return mDB!;

  }

  Future<Database> openDB() async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "notesDB.db");

    return await openDatabase(dbPath, version: 1,
        onCreate: (db, version){

      /// all the tables here...
          db.execute("create table $TABLE_NOTE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATED_AT text)");

    });

  }

  ///queries
  Future<bool> addNote({required String title, required String desc}) async{
    var db = await initDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
      COLUMN_NOTE_CREATED_AT : DateTime.now().millisecondsSinceEpoch.toString()
    });

    return rowsEffected>0;

  }

  Future<List<Map<String,dynamic>>> fetchAllNotes({String query = ""}) async{
    var db = await initDB();

    List<Map<String, dynamic>> allData = await db.query(TABLE_NOTE, where: "$COLUMN_NOTE_TITLE LIKE ? OR $COLUMN_NOTE_DESC LIKE ?", whereArgs: ["%$query%", "%$query%"]);

    return allData;
  }

  ///update
  Future<bool> updateNote({required String title, required String desc, required int id}) async{

    var db = await initDB();
    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
    }, where: "$COLUMN_NOTE_ID = $id");

    return rowsEffected>0;
  }
  ///delete
  Future<bool> deleteNote({required int id}) async{

    var db = await initDB();

    int rowsEffected = await db.delete(TABLE_NOTE, where: "$COLUMN_NOTE_ID = ?", whereArgs: ['$id']);

    return rowsEffected>0;
  }

}
