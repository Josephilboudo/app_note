import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../controllers/database_helper.dart';

class AddNotePage extends StatefulWidget {
  final Note? note;
  final String
      username; // Recuperation du champs username afin d'associe une note a un utilisateur

  AddNotePage({this.note, required this.username});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late DateTime _noteDate;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Pré-remplir les champs si une note est fournie
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _noteDate = widget.note!.date;
    } else {
      _noteDate =
          DateTime.now(); // Utiliser la date actuelle pour une nouvelle note
    }
  }

  // Fonction pour enregistrer la note
  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        date: _noteDate,
        username: widget.username, // Utiliser le champ username
      );

      if (widget.note == null) {
        await _dbHelper.insertNote(note.toMap());
      } else {
        await _dbHelper.updateNote(note.toMap());
      }

      // Affiche un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note enregistrée avec succès'),
          backgroundColor: const Color.fromARGB(255, 5, 70, 7),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  // Fonction pour supprimer la note
  void _deleteNote() async {
    if (widget.note != null) {
      await _dbHelper.deleteNote(widget.note!.id!);

      // Affiche un message de suppression
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note supprimée avec succès'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 145, 151, 227),
        title: Text(widget.note == null ? 'Ajouter une Note' : 'Détail Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color.fromRGBO(181, 6, 6, 0.988),
              ),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est obligatoire';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Contenu',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null, // Permet au champ de texte de s'étendre
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le contenu est obligatoire';
                    }
                    return null;
                  },
                ),
              ),
              if (widget.note != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Date: ${_noteDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
