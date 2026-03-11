import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_colors.dart';
import 'features/notes/data/datasources/notes_remote_datasource.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/presentation/bloc/notes_list_bloc.dart';
import 'features/notes/presentation/screens/create_note_screen.dart';
import 'features/notes/presentation/screens/note_list_screen.dart';

void main() {
  runApp(const QuickNotesApp());
}

class QuickNotesApp extends StatelessWidget {
  const QuickNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // In production, inject via get_it or similar. Base URL: point to backend.
    const baseUrl = 'http://localhost:8080';
    NotesRepository repo = NotesRepositoryImpl(
      NotesRemoteDataSource(baseUrl: baseUrl),
    );

    return MaterialApp(
      title: 'Quick Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => NotesListBloc(repo)..add(NotesListRequested()),
        child: NoteListScreen(
          onCreateTap: (context) => _onCreateTap(context, repo),
        ),
      ),
    );
  }

  static void _onCreateTap(BuildContext context, NotesRepository repo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreateNoteScreen(repo: repo),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<NotesListBloc>().add(NotesListRequested());
      }
    });
  }
}
