import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_list_bloc.dart';
import '../../../../core/theme/app_colors.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({
    super.key,
    required this.onCreateTap,
  });
  final void Function(BuildContext context) onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) {
          if (state is NotesListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotesListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is NotesListLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes yet. Tap + to add one.'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final n = notes[i];
                return ListTile(
                  title: Text(n.title),
                  subtitle: Text(n.body),
                );
              },
            );
          }
          return const Center(child: Text('Pull to load or tap + to add a note.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onCreateTap(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
