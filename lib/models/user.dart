// Creation de la classe utilisateur
class User {
  final int? id;
  final String email;
  final String password;
  final String nom;
  final String prenom;

  User(
      {this.id,
      required this.email,
      required this.password,
      required this.nom,
      required this.prenom});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        nom: map['nom'],
        prenom: map['prenom']);
  }
}
