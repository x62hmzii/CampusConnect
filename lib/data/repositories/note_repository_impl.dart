import 'package:campusconnect/data/datasources/note_local_datasource.dart';
import 'package:campusconnect/data/models/note_model.dart';

class NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepository({required this.localDataSource});

  Future<void> addNote(NoteModel note) async {
    return await localDataSource.addNote(note);
  }

  Future<List<NoteModel>> getNotes() async {
    return await localDataSource.getNotes();
  }

  Future<List<NoteModel>> getFilteredNotes({
    String? degree,
    String? department,
    String? semester,
    String? subject,
  }) async {
    return await localDataSource.getFilteredNotes(
      degree: degree,
      department: department,
      semester: semester,
      subject: subject,
    );
  }

  Future<void> updateNote(String id, NoteModel updatedNote) async {
    return await localDataSource.updateNote(id, updatedNote);
  }

  Future<void> deleteNote(String id) async {
    return await localDataSource.deleteNote(id);
  }
}