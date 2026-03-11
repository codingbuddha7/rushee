import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/note.dart';

/// Calls the backend API. In production, use generated client from OpenAPI.
class NotesRemoteDataSource {
  NotesRemoteDataSource({required this.baseUrl});
  final String baseUrl;

  Future<List<Note>> fetchNotes() async {
    final r = await http.get(Uri.parse('$baseUrl/api/v1/notes'));
    if (r.statusCode != 200) throw Exception('Failed to load notes');
    final list = jsonDecode(r.body) as List;
    return list.map((e) => _noteFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Note> createNote(String title, String body) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/v1/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'body': body}),
    );
    if (r.statusCode != 201) throw Exception('Failed to create note');
    return _noteFromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  static Note _noteFromJson(Map<String, dynamic> j) {
    return Note(
      id: j['id'] as String,
      title: j['title'] as String,
      body: j['body'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
    );
  }
}
