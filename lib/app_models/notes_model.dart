import 'package:firebase_notes_app/App_constants/App_constants.dart';

class NotesModel {
  String title;
  String description;
  int created_at;
  int updated_at;

  NotesModel({
    required this.title,
    required this.description,
    required this.created_at,
    required this.updated_at,
  });

  //From Map to Model
  factory NotesModel.fromMap(Map<String, dynamic> myMap) {
    return NotesModel(
      title: myMap[AppNotesConstants.notes_title],
      description: myMap[AppNotesConstants.notes_description],
      created_at: myMap[AppNotesConstants.created_at],
      updated_at: myMap[AppNotesConstants.updated_at],
    );
  }

  Map<String, dynamic> modelToMap() {
    return {
      AppNotesConstants.notes_title: title,
      AppNotesConstants.notes_description: description,
      AppNotesConstants.created_at: created_at,
      AppNotesConstants.updated_at: updated_at,
    };
  }
}
