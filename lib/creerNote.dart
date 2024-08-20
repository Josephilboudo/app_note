import 'package:flutter/material.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotePage(),
    );
  }
}

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 10, // This makes the content field bigger
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _saveNote,
                child: Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    String title = _titleController.text;
    String content = _contentController.text;

    // For now, we just print the note data to the console
    print('Title: $title');
    print('Content: $content');

    // You can add more functionality here, like saving the note to a database

    // Optionally clear the text fields after saving
    _titleController.clear();
    _contentController.clear();

    // Optionally show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note Saved!')),
    );
  }
}
