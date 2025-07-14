abstract class NoteState{}

class NoteInitialState extends NoteState{}
class NoteLoadingState extends NoteState{}
class NoteLoadedState extends NoteState{
  List<Map<String,dynamic>> mNotes;
  NoteLoadedState({required this.mNotes});
}
class NoteErrorState extends NoteState{
  String errorMsg;
  NoteErrorState({required this.errorMsg});
}
class MyNoteState{

}





