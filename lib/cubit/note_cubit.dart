import 'package:db_exp_395/cubit/note_state.dart';
import 'package:db_exp_395/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<NoteState>{
  DbHelper dbHelper;
  NoteCubit({required this.dbHelper}) : super(NoteInitialState());

  ///events
  addNotes({required String title, required String desc}) async{
    emit(NoteLoadingState());
    bool isAdded = await dbHelper.addNote(title: title, desc: desc);
    if(isAdded){
      getAllNotes();
    } else {
      emit(NoteErrorState(errorMsg: "Something went wrong"));
    }
  }

  updateNote({required String title, required String desc, required int id}) async{
    emit(NoteLoadingState());
    bool isUpdated = await dbHelper.updateNote(title: title, desc: desc, id: id);
    if(isUpdated){
      getAllNotes();
    } else {
      emit(NoteErrorState(errorMsg: "Something went wrong"));
    }

  }

  deleteNote({required int id}) async{
    emit(NoteLoadingState());
    bool isDeleted = await dbHelper.deleteNote(id: id);
    if(isDeleted){
      getAllNotes();
    } else {
      emit(NoteErrorState(errorMsg: "Something went wrong"));
    }
  }

  getAllNotes() async{
    List<Map<String, dynamic>> mNotes = await dbHelper.fetchAllNotes();
    emit(NoteLoadedState(mNotes: mNotes));
  }

}