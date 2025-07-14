import 'package:db_exp_395/cubit/note_cubit.dart';
import 'package:db_exp_395/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';

class AddNotePage extends StatefulWidget {

  bool isUpdate;
  int? id;
  String? title;
  String? desc;

  AddNotePage({this.isUpdate = false, this.id, this.title, this.desc});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  var titleController = TextEditingController();

  var descController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Update Note' : 'Add Note',),
      ),
      body: bottomSheetUI(),
    );
  }

  Widget bottomSheetUI() {

    if(widget.isUpdate){
      titleController.text = widget.title!;
      descController.text = widget.desc!;
    }

    return Container(
      padding: EdgeInsets.all(11),
      child: Center(
        child: Column(
          children: [
            /*Text(
              widget.isUpdate ? 'Update Note' : 'Add Note',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),*/
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

                    if(titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                      if (widget.isUpdate) {
                        //context.read<DBProvider>().updateNote(title: titleController.text, desc: descController.text, id: widget.id!);
                        context.read<NoteCubit>().updateNote(title: titleController.text, desc: descController.text, id: widget.id!);
                      } else {
                        //context.read<DBProvider>().addNote(title: titleController.text, desc: descController.text);
                        context.read<NoteCubit>().addNotes(title: titleController.text, desc: descController.text);
                      }

                      Navigator.pop(context);

                      /*if (check) {
                        getAllNotes();
                        Navigator.pop(context);
                      }*/
                    } else {

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
    );
  }
}
