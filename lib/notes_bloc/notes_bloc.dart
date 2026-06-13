import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/notes_bloc/notes_event.dart';
import 'package:firebase_notes_app/notes_bloc/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  FirebaseFirestore myFirebase = FirebaseFirestore.instance;

  NotesBloc() : super(InitialNotesState()) {
    on<AddNotesEvent>((event, emit) async {
      emit(LoadingNotesState());

      DocumentReference<Map<String, dynamic>> addedNote = await myFirebase
          .collection(AppUserConstants.collection_user_name)
          .doc(event.userId)
          .collection(AppNotesConstants.collection_notes_name)
          .add(event.notesModel.modelToMap());

      if (addedNote.id.isNotEmpty) {
        emit(
          LoadedNotesState(
            allNotes: await myFirebase
                .collection(AppUserConstants.collection_user_name)
                .doc(event.userId)
                .collection(AppNotesConstants.collection_notes_name)
                .get(),
          ),
        );
      }
    });

    on<FetchNotesEvent>((event, emit) async {
      emit(LoadingNotesState());

      emit(
        LoadedNotesState(
          allNotes: await myFirebase
              .collection(AppUserConstants.collection_user_name)
              .doc(event.userId)
              .collection(AppNotesConstants.collection_notes_name)
              .orderBy(event.filterType, descending: true)
              .get(),
        ),
      );
    });

    on<DeleteNotesEvent>((event, emit) async {
      emit(LoadingNotesState());

      myFirebase
          .collection(AppUserConstants.collection_user_name)
          .doc(event.userId)
          .collection(AppNotesConstants.collection_notes_name)
          .doc(event.notesId)
          .delete();

      emit(
        LoadedNotesState(
          allNotes: await myFirebase
              .collection(AppUserConstants.collection_user_name)
              .doc(event.userId)
              .collection(AppNotesConstants.collection_notes_name)
              .get(),
        ),
      );
    });

    on<UpdateNotesEvent>((event, emit) async {
      emit(LoadingNotesState());

      myFirebase
          .collection(AppUserConstants.collection_user_name)
          .doc(event.userId)
          .collection(AppNotesConstants.collection_notes_name)
          .doc(event.notesId)
          .update({
        AppNotesConstants.notes_title: event.title,
        AppNotesConstants.notes_description: event.description,
        AppNotesConstants.updated_at : event.updated_at
          });
      emit(
        LoadedNotesState(
          allNotes: await myFirebase
              .collection(AppUserConstants.collection_user_name)
              .doc(event.userId)
              .collection(AppNotesConstants.collection_notes_name)
              .get(),
        ),
      );
    });
  }
}
