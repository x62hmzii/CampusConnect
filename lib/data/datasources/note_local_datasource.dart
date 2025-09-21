import 'package:hive/hive.dart';
import 'package:campusconnect/data/models/note_model.dart';

class NoteLocalDataSource {
  static const String _boxName = 'notes';

  Future<Box<NoteModel>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<NoteModel>(_boxName);
    }
    return Hive.box<NoteModel>(_boxName);
  }

  Future<void> addNote(NoteModel note) async {
    final box = await _openBox();
    await box.add(note);
  }

  Future<List<NoteModel>> getNotes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<List<NoteModel>> getFilteredNotes({
    String? degree,
    String? department,
    String? semester,
    String? subject,
  }) async {
    final box = await _openBox();
    var notes = box.values.toList();

    if (degree != null && degree.isNotEmpty) {
      notes = notes.where((note) => note.degree == degree).toList();
    }

    if (department != null && department.isNotEmpty) {
      notes = notes.where((note) => note.department == department).toList();
    }

    if (semester != null && semester.isNotEmpty) {
      notes = notes.where((note) => note.semester == semester).toList();
    }

    if (subject != null && subject.isNotEmpty) {
      notes = notes.where((note) => note.subject == subject).toList();
    }

    return notes;
  }

  Future<void> updateNote(String id, NoteModel updatedNote) async {
    final box = await _openBox();
    final noteKey = _getNoteKeyById(id, box);
    if (noteKey != null) {
      await box.put(noteKey, updatedNote);
    }
  }

  Future<void> deleteNote(String id) async {
    final box = await _openBox();
    final noteKey = _getNoteKeyById(id, box);
    if (noteKey != null) {
      await box.delete(noteKey);
    }
  }

  int? _getNoteKeyById(String id, Box<NoteModel> box) {
    for (var i = 0; i < box.length; i++) {
      final key = box.keyAt(i);
      final note = box.get(key);
      if (note?.id == id) {
        return key;
      }
    }
    return null;
  }
}