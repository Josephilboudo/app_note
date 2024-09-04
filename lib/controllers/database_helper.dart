import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');

    return await openDatabase(
      path,
      version: 3, // Version 3 pour inclure le champ username
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            username TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE notes ADD COLUMN date TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE notes ADD COLUMN username TEXT');
        }
      },
    );
  }

  // Fonction pour insérer une note
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.insert('notes', note);
  }

  // Fonction pour mettre à jour une note
  Future<int> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    return await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }

  // Fonction pour supprimer une note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fonction pour récupérer toutes les notes
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes');
  }

  // Fonction pour récupérer une note par son ID
  Future<Map<String, dynamic>?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Fonction pour récupérer toutes les notes d'un utilisateur spécifique
  Future<List<Map<String, dynamic>>> getNotesByUser(String username) async {
    final db = await database;
    return await db.query(
      'notes',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Fonction pour supprimer toutes les notes d'un utilisateur spécifique
  Future<int> deleteNotesByUser(String username) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Fonction pour supprimer toutes les notes (utilisé pour le nettoyage de la base de données)
  Future<int> deleteAllNotes() async {
    final db = await database;
    return await db.delete('notes');
  }

  // Fonction pour compter le nombre total de notes
  Future<int> countNotes() async {
    final db = await database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM notes')) ??
        0;
  }
}
