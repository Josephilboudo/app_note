import 'package:app_note/views/app_views/home_page.dart';
import 'package:flutter/material.dart';
import '../../controllers/userdatabase_helper.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserDatabaseHelper _dbHelper = UserDatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();

  void _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final nom = _nomController.text.trim();
    final prenom = _nomController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        await _dbHelper.registerUser(nom, prenom, username, password);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Inscription réussie')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotesPage(username: username)),
        ); // Redirection vers la page des notes après l'inscription
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : Nom d\'utilisateur déjà pris')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez remplir tous les champs')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image circulaire
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: 150, // Taille de l'image
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icon/icon.png'),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              // Champs de texte pour l'inscription
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prenom',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
