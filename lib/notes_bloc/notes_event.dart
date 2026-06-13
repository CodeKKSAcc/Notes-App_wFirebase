import 'package:firebase_notes_app/app_models/notes_model.dart';

import '../App_constants/App_constants.dart';

abstract class NotesEvent {}

class AddNotesEvent extends NotesEvent {
  String userId;
  NotesModel notesModel;

  AddNotesEvent({required this.userId, required this.notesModel});
}

class FetchNotesEvent extends NotesEvent {
  String userId;
  String filterType;

  FetchNotesEvent({required this.userId, this.filterType = AppNotesConstants.created_at});
}

class DeleteNotesEvent extends NotesEvent {
  String notesId;
  String userId;

  DeleteNotesEvent({required this.userId, required this.notesId});
}

class UpdateNotesEvent extends NotesEvent {
  String title;
  String description;
  int updated_at;
  String userId;
  String notesId;

  UpdateNotesEvent({
    required this.title,
    required this.description,
    required this.userId,
    required this.notesId,
    required this.updated_at,
  });
}
