import 'package:sqflite/sqflite.dart' as sql;

class DbNotes {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""create table database(
    id integer primary key autoincrement not null,
    title text,
    description text,
    createdAt timestamp not null default current_timestamp  
    )""");
    Future<sql.Database> db() async {
      return sql.openDatabase("db_name.db", version: 1,
          onCreate: (sql.Database database, int version) async {
        await createTables(database);
      });
    }

    Future<int> createData(String title, String? description) async {
      final db = await DbNotes.db();
      final data = {'title': title, 'description': description};
      final id = await db.insert('data', data,
          ConflictAlgorithm: sql.ConflictAlgorithm.replace);
      return id;
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DbNotes.db();
    return db.query('data', orderby: 'id');
  }

  static Future<List<Map<String, dynamic>>> getDataId(int id) async {
    final db = await DbNotes.db();
    return db.query('data', where: "id= ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String title, String? description) async {
    final db = DbNotes.db();
    final data = {
      'title': title,
      'description': description,
      //     'createdAt': DataTime.now().toString(),
    };
    final result =
        await db.update('data', data, where: "id= ?", whereArgs: [id]);
    return result;
  }

  static Future<void> delete(int id) async {
    final db = DbNotes.db();
    try {
      db.delete('data', where: "id= ?", whereArgs: [id]);
    } catch (e) {}
  }

  static db() {}

  static createData(String s, String t) {}
}
