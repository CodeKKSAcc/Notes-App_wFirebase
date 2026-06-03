

abstract class NotesEvent {}

class AddNotesEvent extends NotesEvent {
  String title;
  String description;
  int createdAt;

  AddNotesEvent({
    required this.title,
    required this.description,
    required this.createdAt,
  });
}

class FetchNotesEvent extends NotesEvent {}

class DeleteNotesEvent extends NotesEvent {
  String id;

  DeleteNotesEvent({required this.id});
}

class UpdateNotesEvent extends NotesEvent {

  String title;
  String description;
  String id;
  UpdateNotesEvent({required this.title, required this.description, required this.id});
}
