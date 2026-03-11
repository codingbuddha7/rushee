import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl(this._remote);
  final NotesRemoteDataSource _remote;

  @override
  Future<List<Note>> listNotes() => _remote.fetchNotes();

  @override
  Future<Note> createNote({required String title, required String body}) =>
      _remote.createNote(title, body);
}
