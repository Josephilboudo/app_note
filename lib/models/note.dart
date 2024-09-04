class Note {
  int? id;
  String title;
  String content;
  DateTime date;
  String username; // Nouveau champ pour lier une note à un utilisateur

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.username, // Initialisation du champ username
  });

  // Convertir un objet Note en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'username': username, // Ajout du champ username
    };
  }

  // Créer un objet Note à partir d'un Map
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      username: map['username'], // Ajout du champ username
    );
  }
}
