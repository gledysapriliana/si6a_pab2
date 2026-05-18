class Note {
  final String? id;
  final String title;
  final String description;
  final String? imageBase64;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageBase64,
    required this.createdAt,
  });

  /// Create a Note from a Firestore document snapshot
  factory Note.fromMap(String id, Map<String, dynamic> map) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageBase64: map['imageBase64'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert Note to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageBase64': imageBase64,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}