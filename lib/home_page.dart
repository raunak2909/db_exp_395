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
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ///DbHelper dbHelper = DbHelper();
    dbHelper = DbHelper.getInstance();
    getAllNotes();
  }

  void getAllNotes() async {
    allNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    leading: Text(
                      "${index+1}",
                    ),
                    title: Text(allNotes[index][DbHelper.COLUMN_NOTE_TITLE]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(allNotes[index][DbHelper.COLUMN_NOTE_DESC]),
                        Text(
                          df.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                allNotes[index][DbHelper
                                    .COLUMN_NOTE_CREATED_AT],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async{
                            bool isUpdated = await dbHelper!.updateNote(
                              title: "Updated Note",
                              desc: "This is also updated!!",
                              id: allNotes[index][DbHelper.COLUMN_NOTE_ID],
                            );

                            if(isUpdated){
                              getAllNotes();
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async{

                            showModalBottomSheet(context: context, builder: (_){
                              return Container(
                                padding: EdgeInsets.all(11),
                                height: 140,
                                child: Column(
                                  children: [
                                    Text("Are you sure want to DELETE?", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                                    SizedBox(width: 11,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      bool isDeleted = await dbHelper!.deleteNote(id: allNotes[index][DbHelper.COLUMN_NOTE_ID]);
                                      if(isDeleted){
                                        getAllNotes();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes'),
                                  ),
                                  SizedBox(width: 11),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                                  ],
                                ),
                              );
                            });

                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("No Notes yet!!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.text = "";
          showModalBottomSheet(
            //isDismissible: false,
            //enableDrag: false,
            context: context,
            builder: (_) => Container(
              padding: EdgeInsets.all(11),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 21),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Title',
                        hintText: 'Enter Note Title',
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      minLines: 4,
                      maxLines: 4,
                      controller: descController,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        labelText: 'Desc',
                        hintText: 'Enter Note Desc',
                      ),
                    ),
                    SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            bool check = await dbHelper!.addNote(
                              title: titleController.text,
                              desc: descController.text,
                            );

                            if (check) {
                              getAllNotes();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Save'),
                        ),
                        SizedBox(width: 11),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
