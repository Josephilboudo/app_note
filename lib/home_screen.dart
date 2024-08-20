import 'package:app_note/db_notes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

//Chargement des donnees depuis la base de donnees
  void _refreshData() async {
    final data = await DbNotes.getData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Titre de la note",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Contenu de la note",
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _allData;
                  }
                  if (id != null) {
                    await updateData(id);
                  }
                  _titleController.text = "";
                  _descriptionController.text = "";
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child:
                      Text(id == null ? "Ajouter du texte" : "Mettre a jour"),
                  //style:
                  //TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //ajout d'une note
  Future<void> _addData() async {
    await DbNotes.createData(
        _titleController.text, _descriptionController.text);
    _refreshData();
  }

// Mise a jour d'une note
  Future<void> updateData(int id) async {
    await DbNotes.updateData(
        id, _titleController.text, _descriptionController.text);
    _refreshData();
  }

//Suppression d'une note
  void _delete(int id) async {
    await DbNotes.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent, content: Text("Note supprimee")));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Text("Operations Crud"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _allData[index]['title'],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      subtitle: Text(_allData[index]['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showBottomSheet(_allData[index]['id']);
                              },
                              icon: Icon(Icons.edit, color: Colors.indigo)),
                          IconButton(
                              onPressed: () {
                                _delete(_allData[index]['id']);
                              },
                              icon: Icon(Icons.delete, color: Colors.red))
                        ],
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet(null), child: Icon(Icons.add)),
    );
  }
}
