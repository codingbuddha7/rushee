import '../entities/note.dart';

/// Domain contract for notes. Implemented in data layer.
abstract class NotesRepository {
  Future<List<Note>> listNotes();
  Future<Note> createNote({required String title, required String body});
}
