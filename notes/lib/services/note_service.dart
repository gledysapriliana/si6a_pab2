import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference _notesCollection = FirebaseFirestore.instance
      .collection('notes');

  /// Stream of all notes, ordered by creation date (newest first)
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Note.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  /// Add a new note to Firestore
  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
  }

  /// Update an existing note in Firestore
  Future<void> updateNote(Note note) async {
    if (note.id == null) return;
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  /// Delete a note from Firestore
  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }
}
