import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';

// Events
abstract class NotesListEvent {}
class NotesListRequested extends NotesListEvent {}

// State
abstract class NotesListState {}
class NotesListInitial extends NotesListState {}
class NotesListLoading extends NotesListState {}
class NotesListLoaded extends NotesListState {
  NotesListLoaded(this.notes);
  final List<Note> notes;
}
class NotesListError extends NotesListState {
  NotesListError(this.message);
  final String message;
}

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  NotesListBloc(this._repo) : super(NotesListInitial()) {
    on<NotesListRequested>(_onRequested);
  }
  final NotesRepository _repo;

  Future<void> _onRequested(NotesListRequested e, Emitter<NotesListState> emit) async {
    emit(NotesListLoading());
    try {
      final notes = await _repo.listNotes();
      emit(NotesListLoaded(notes));
    } catch (err) {
      emit(NotesListError(err.toString()));
    }
  }
}
