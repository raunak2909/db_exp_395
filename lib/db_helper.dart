import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  /// private constructor
  DbHelper._();
  /// singleton
  static DbHelper getInstance() => DbHelper._();

  Database? mDB;

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

    });

  }

  ///queries
  void addNote() async{
    var db = await initDB();

  }

  void fetchAllNotes() async{
    var db = await initDB();

  }

}
