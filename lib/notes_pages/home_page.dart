import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/notes_bloc/notes_bloc.dart';
import 'package:firebase_notes_app/notes_bloc/notes_event.dart';
import 'package:firebase_notes_app/notes_bloc/notes_state.dart';
import 'package:firebase_notes_app/notes_pages/add_notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(FetchNotesEvent());
  }

  DateFormat myDf = DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is LoadingNotesState) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (state is ErrorNotesState) {
            return Center(
              child: Text(
                state.errorMsg,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            );
          }

          if (state is LoadedNotesState) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> allData =
                state.allNotes.docs;

            print(allData.length);

            return allData.isNotEmpty
                ? GridView.builder(
                    itemCount: allData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 360,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNotesPage(
                                toUpdate: true,
                                title: allData[index]
                                    .data()[AppConstants.notes_title],
                                description: allData[index]
                                    .data()[AppConstants.notes_description],
                                id: allData[index].id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(9),
                          margin: EdgeInsets.only(top: 15, left: 15),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(27),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      allData[index]
                                          .data()[AppConstants.notes_title],
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 18),
                                  IconButton(
                                    onPressed: () {
                                      context.read<NotesBloc>().add(
                                        DeleteNotesEvent(id: allData[index].id),
                                      );
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                              Divider(),
                              Text(
                                allData[index]
                                    .data()[AppConstants.notes_description],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 11,
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment(0.9, 0.81),
                                child: Text(
                                  myDf.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      allData[index]
                                          .data()[AppConstants.created_at],
                                    ),
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No Notes Yet !!!",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
            ;
          }

          return Center(
            child: Text(
              "Unknown Error !!!",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotesPage(toUpdate: false),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
