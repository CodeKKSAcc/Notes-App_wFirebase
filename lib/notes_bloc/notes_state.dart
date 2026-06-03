

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NotesState {}

class InitialNotesState extends NotesState {}

class LoadingNotesState extends NotesState {}

class LoadedNotesState extends NotesState {

  QuerySnapshot<Map<String, dynamic>> allNotes;// List<QueryDocumentSnapshot<Map<String, dynamic>>>
  LoadedNotesState({required this.allNotes});
}

class ErrorNotesState extends NotesState {

  String errorMsg;
  ErrorNotesState({required this.errorMsg});
}