import 'package:db_exp_395/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper? dbHelper;
  List<Map<String, dynamic>> allNotes = [];
  DateFormat df = DateFormat.yMMMEd();

  @override
  void initState() {
    super.initState();
    ///DbHelper dbHelper = DbHelper();
    dbHelper = DbHelper.getInstance();
    getAllNotes();
  }

  void getAllNotes() async{
    allNotes = await dbHelper!.fetchAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: allNotes.isNotEmpty ? ListView.builder(
        itemCount: allNotes.length,
          itemBuilder: (_, index){

        return Card(
          child: ListTile(
            title: Text(allNotes[index][DbHelper.COLUMN_NOTE_TITLE]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(allNotes[index][DbHelper.COLUMN_NOTE_DESC]),
                Text(df.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index][DbHelper.COLUMN_NOTE_CREATED_AT])))),
              ],
            ),
          ),
        );

      }) : Center(child: Text("No Notes yet!!"),),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        bool check = await dbHelper!.addNote(title: "New Note", desc: "This is Amazing!!");
        if(check){
          print("Note Added");
          getAllNotes();
        }
      }, child: Icon(Icons.add),),
    );
  }
}
