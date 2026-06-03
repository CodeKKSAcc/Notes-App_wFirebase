

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/notes_bloc/notes_event.dart';
import 'package:firebase_notes_app/notes_bloc/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState>{

  FirebaseFirestore myFirebase = FirebaseFirestore.instance;

  NotesBloc() : super(InitialNotesState()){

    on<AddNotesEvent>((event, emit) async{
      emit(LoadingNotesState());

      DocumentReference<Map<String, dynamic>> addedNote = await myFirebase.collection(AppConstants.collection_name).add({
        AppConstants.notes_title : event.title,
        AppConstants.notes_description : event.description,
        AppConstants.created_at : event.createdAt,
      });

      if(addedNote.id.isNotEmpty){
        emit(LoadedNotesState(allNotes: await myFirebase.collection(AppConstants.collection_name).get()));
      }

    });

    on<FetchNotesEvent>((event, emit) async{
      emit(LoadingNotesState());

      emit(LoadedNotesState(allNotes: await myFirebase.collection(AppConstants.collection_name).get()));
    });

    on<DeleteNotesEvent>((event, emit) async{
      emit(LoadingNotesState());

      myFirebase.collection(AppConstants.collection_name).doc(event.id).delete();

      emit(LoadedNotesState(allNotes: await myFirebase.collection(AppConstants.collection_name).get()));
    });

    on<UpdateNotesEvent>((event, emit) async{
      emit(LoadingNotesState());

      myFirebase.collection(AppConstants.collection_name).doc(event.id).update({
        AppConstants.notes_title : event.title,
        AppConstants.notes_description : event.description
      });
      emit(LoadedNotesState(allNotes: await myFirebase.collection(AppConstants.collection_name).get()));
    });
  }
}