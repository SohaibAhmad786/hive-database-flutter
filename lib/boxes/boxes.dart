

import 'package:hive/hive.dart';
import 'package:hive_db/model/notes_model.dart';

class Boxes {
  static Box<NotesModel> getNotesData ()=> Hive.box<NotesModel>('notes');
}
