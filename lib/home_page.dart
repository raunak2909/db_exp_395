import 'package:db_exp_395/add_note_page.dart';
import 'package:db_exp_395/db_helper.dart';
import 'package:db_exp_395/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DateFormat df = DateFormat.yMMMEd();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  int isChecked = 0;

  @override
  void initState() {
    super.initState();

    ///DbHelper dbHelper = DbHelper();
    context.read<DBProvider>().getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: /* Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: isChecked==1, onChanged: (value){
            isChecked = value! ? 1 : 0;
            setState(() {});
          }, activeColor: Colors.amber,),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: isChecked==1, onChanged: (value){
            isChecked = value! ? 1 : 0;
            setState(() {});
          },
            title: Text('CheckboxListTile'),
            subtitle: Text('CheckboxListTile subtitle'),
          ),
        ],
      ),*/ Column(
        children: [
          SearchBar(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            leading: Icon(Icons.search),
            onChanged: (value) async {
              Future.delayed(Duration(seconds: 2));
              context.read<DBProvider>().filterNotes(query: value);
            },
          ),
          SizedBox(height: 16),
          Consumer<DBProvider>(
            builder: (_, provider, __) {
              allNotes = provider.getData();

              return Expanded(
                child: allNotes.isNotEmpty
                    ? ListView.builder(
                        itemCount: allNotes.length,
                        itemBuilder: (_, index) {
                          return Card(
                            child: ListTile(
                              leading: Text("${index + 1}"),
                              title: Text(
                                allNotes[index][DbHelper.COLUMN_NOTE_TITLE],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allNotes[index][DbHelper.COLUMN_NOTE_DESC],
                                  ),
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
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddNotePage(
                                            isUpdate: true,
                                            id:
                                                allNotes[index][DbHelper
                                                    .COLUMN_NOTE_ID],
                                            title:
                                                allNotes[index][DbHelper
                                                    .COLUMN_NOTE_TITLE],
                                            desc:
                                                allNotes[index][DbHelper
                                                    .COLUMN_NOTE_DESC],
                                          ),
                                        ),
                                      );
                                      /*titleController.text = allNotes[index][DbHelper.COLUMN_NOTE_TITLE];
                                      descController.text = allNotes[index][DbHelper.COLUMN_NOTE_DESC];
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => bottomSheetUI(
                                          isUpdate: true,
                                          id: allNotes[index][DbHelper.COLUMN_NOTE_ID],
                                        ),
                                      );*/
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (_) {
                                          return Container(
                                            padding: EdgeInsets.all(11),
                                            height: 140,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Are you sure want to DELETE?",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 11),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        context
                                                            .read<DBProvider>()
                                                            .deleteNote(
                                                              id:
                                                                  allNotes[index][DbHelper
                                                                      .COLUMN_NOTE_ID],
                                                            );
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
                                        },
                                      );
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
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          /*titleController.clear();
          descController.text = "";
          showModalBottomSheet(
            //isDismissible: false,
            //enableDrag: false,
            context: context,
            builder: (_) => bottomSheetUI(),
          );*/
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
