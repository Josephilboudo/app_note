import 'package:flutter/material.dart';
import '../../controllers/userdatabase_helper.dart';
import '../../views/app_views/home_page.dart'; // Assure-toi que la page principale est bien importée

class UserInfoPage extends StatefulWidget {
  final String username; // Nom d'utilisateur passé en paramètre

  UserInfoPage({required this.username});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final UserDatabaseHelper _dbHelper = UserDatabaseHelper();
  Map<String, dynamic>? userInfo; // Stocker les infos de l'utilisateur
  bool _isPasswordVisible =
      false; // Variable pour gérer l'affichage du mot de passe

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Récupérer les informations de l'utilisateur
  void _fetchUserInfo() async {
    final info = await _dbHelper.getUserInfo(widget.username);
    setState(() {
      userInfo = info; // Assigner les infos récupérées à userInfo
    });
  }

  // Fonction pour retourner à la page principale
  void _goToNotesPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotesPage(username: widget.username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 145, 151, 227),
        actions: [
          IconButton(
            icon: Icon(Icons.home),

            color: Color.fromRGBO(255, 255, 255, 0.984),
            // Icône pour retourner à la page principale
            onPressed: _goToNotesPage, // Retour à la page principale
          ),
        ],
        title: Text('Informations utilisateur'),
      ),
      body: userInfo == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Afficher un loader en attendant les infos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage des informations de l'utilisateur
                  Text(
                    'Nom : ${userInfo!['nom']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Prénom : ${userInfo!['prenom']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nom d\'utilisateur : ${userInfo!['username']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Champs de mot de passe masqué
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isPasswordVisible
                              ? 'Mot de passe : ${userInfo!['password']}'
                              : 'Mot de passe : *****',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
