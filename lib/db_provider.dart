import 'package:db_exp_395/db_helper.dart';
import 'package:flutter/cupertino.dart';

class DBProvider with ChangeNotifier{
  DbHelper dbHelper;
  DBProvider({required this.dbHelper});

  ///
  List<Map<String, dynamic>> _mData = [];

  ///events
  List<Map<String, dynamic>> getData() => _mData;
  addNote({required String title, required String desc}) async{
    bool isAdded = await dbHelper.addNote(title: title, desc: desc);
    if(isAdded){
      getAllNotes();
    }
  }

  updateNote({required String title, required String desc, required int id}) async{
    bool isUpdated = await dbHelper.updateNote(title: title, desc: desc, id: id);
    if(isUpdated){
      getAllNotes();
    }
  }

  deleteNote({required int id}) async{
    bool isDeleted = await dbHelper.deleteNote(id: id);
    if(isDeleted){
      getAllNotes();
    }
  }

  getAllNotes() async {
    _mData = await dbHelper.fetchAllNotes();
    notifyListeners();
  }

  filterNotes({required String query}) async{
    _mData = await dbHelper.fetchAllNotes(query: query);
    notifyListeners();

  }

}