import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseHelper {
  static final UserDatabaseHelper _instance = UserDatabaseHelper._internal();
  factory UserDatabaseHelper() => _instance;
  static Database? _database;

  UserDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            nom TEXT,
            prenom TEXT
          )
        ''');
      },
    );
  }

  Future<int> registerUser(
      String nom, String prenom, String username, String password) async {
    final db = await database;
    return await db.insert('users', {
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'password': password
    });
  }

  // Méthode pour obtenir les informations utilisateur par username
  Future<Map<String, dynamic>?> getUserInfo(String username) async {
    final db = await database;
    final result =
        await db.query('users', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    final result = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return result.isNotEmpty ? result.first : null;
  }
}
