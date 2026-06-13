import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/app_models/notes_model.dart';
import 'package:firebase_notes_app/notes_bloc/notes_bloc.dart';
import 'package:firebase_notes_app/notes_bloc/notes_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNotesPage extends StatefulWidget {
  @override
  State<AddNotesPage> createState() => _AddNotesPageState();

  bool toUpdate;
  String title;
  String description;
  String userId;
  String notesId;

  AddNotesPage({
    required this.toUpdate,
    this.title = "",
    this.description = "",
    this.userId = "",
    this.notesId = "",
  });
}

class _AddNotesPageState extends State<AddNotesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FirebaseFirestore? myFirebase;

  @override
  void initState() {
    super.initState();
    myFirebase = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.toUpdate ? "Update" : "Add"} Notes Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: addUi(
        toUpdate: widget.toUpdate,
        title: widget.title,
        description: widget.description,
        userId: widget.userId,
        notedId: widget.notesId,
      ),
    );
  }

  Widget addUi({
    required bool toUpdate,
    int index = 0,
    String title = "",
    String description = "",
    String userId = "",
    String notedId = "",
  }) {
    if (toUpdate) {
      titleController.text = title;
      descriptionController.text = description;
    }

    return Padding(
      padding: EdgeInsets.only(top: 24, right: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              hintText: "Enter the title here...",
              labelText: "Title",
            ),
          ),
          SizedBox(height: 18),
          TextField(
            controller: descriptionController,
            maxLines: 9,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              hintText: "Enter the description here...",
              labelText: "Description",
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (toUpdate) {
                    context.read<NotesBloc>().add(
                      UpdateNotesEvent(
                        title: titleController.text,
                        description: descriptionController.text,
                        updated_at: DateTime.now().millisecondsSinceEpoch,
                        userId: userId,
                        notesId: notedId,
                      ),
                    );
                  } else {
                    context.read<NotesBloc>().add(
                      AddNotesEvent(
                        userId: widget.userId,
                        notesModel: NotesModel(
                          title: titleController.text,
                          description: descriptionController.text,
                          created_at: DateTime.now().millisecondsSinceEpoch,
                          updated_at: DateTime.now().millisecondsSinceEpoch,
                        ),
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
              SizedBox(width: 18),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
