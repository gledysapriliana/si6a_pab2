class Note {
  String? id;
  String title;
  String description;
  String? imageBase64;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageBase64,
  });

  // Konversi dari Firestore document ke Note object
  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageBase64: map['imageBase64'],
    );
  }

  // Konversi dari Note object ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageBase64': imageBase64,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
