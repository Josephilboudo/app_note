import 'package:flutter/material.dart';
import '../../controllers/database_helper.dart';
import '../../models/note.dart';
import 'add_note_page.dart';
import '../auth_views/login_page.dart';
import 'package:intl/intl.dart';
import 'userInfo.dart';

class NotesPage extends StatefulWidget {
  final String
      username; // Nom d'utilisateur passé en paramètre apres l'authentification pour savoir qui est connecter

  NotesPage({required this.username});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  TextEditingController _searchController = TextEditingController();

  //Ceci concerne le filtrage de la zone de recherche
  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _searchController.addListener(() {
      _filterNotes();
    });
  }

  // Récupère les notes de l'utilisateur connecté
  void _fetchNotes() async {
    final notesMap = await _dbHelper.getNotesByUser(widget.username);
    setState(() {
      _notes = notesMap.map((note) => Note.fromMap(note)).toList();
      _notes.sort(
          (a, b) => b.date.compareTo(a.date)); // Trier par date décroissante
      _filteredNotes = _notes;
    });
  }

  // Filtrer les notes selon le texte de recherche
  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        return titleLower.contains(query) || contentLower.contains(query);
      }).toList();
    });
  }

  // Fonction pour ajouter ou éditer une note
  Future<void> _addOrEditNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddNotePage(username: widget.username)),
    );
    if (result == true) {
      _fetchNotes();
    }
  }

  // Fonction pour déconnecter l'utilisateur
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Rediriger vers la page de login
    );
  }

  // Fonction pour déconnecter l'utilisateur
  void _goToUserInfoPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UserInfoPage(
              username: widget.username)), // Rediriger vers la page de login
    );
  }

  // Fonction pour afficher un aperçu du contenu de la note
  String _getPreviewText(String content) {
    List<String> words = content.split(' ');
    if (words.length > 4) {
      return words.take(4).join(' ') +
          '...'; // Affiche les 4 premiers mots suivis de "..."
    } else {
      return content; // Affiche le contenu complet s'il a moins de 4 mots
    }
  }

  // Fonction pour formater la date
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date); // Format de la date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 145, 151, 227),
        title: Text('Notes'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.account_circle,
                    color: Color.fromRGBO(255, 255, 255,
                        0.984)), // Icône pour accéder aux informations de l'utilisateur
                onPressed:
                    _goToUserInfoPage, // Appelle la fonction pour naviguer vers la page des infos utilisateur
              ),
              IconButton(
                icon: Icon(Icons.logout), // Icône de déconnexion
                onPressed: _logout, // Appel de la fonction de déconnexion
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          _filteredNotes[index].title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPreviewText(_filteredNotes[index].content),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatDate(_filteredNotes[index].date),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNotePage(
                                note: _filteredNotes[index],
                                username: widget
                                    .username, // Passer le nom d'utilisateur
                              ),
                            ),
                          );
                          if (result == true) {
                            _fetchNotes();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: _addOrEditNote,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
