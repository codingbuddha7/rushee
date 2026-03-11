import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt];
}
