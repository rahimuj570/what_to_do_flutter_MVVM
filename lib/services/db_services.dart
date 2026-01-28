import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbServices {
  static Database? _db;
  final String todoTableName = 'todos';

  Future<Database> _initDb() async {
    String dbPath = await getDatabasesPath();
    String dbName = 'what_to_do.db'; // optional: add .db extension
    String path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $todoTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            todo TEXT NOT NULL,
            deadline INTEGER,
            status INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop and recreate if upgrading
        await db.execute('DROP TABLE IF EXISTS $todoTableName');
        await db.execute(''' 
        CREATE TABLE $todoTableName 
          ( id INTEGER PRIMARY KEY AUTOINCREMENT, 
          todo TEXT NOT NULL, 
          deadline INTEGER, 
          status INTEGER NOT NULL ) 
          ''');
      },
    );
  }

  Future<Database> get getDatabase async {
    _db ??= await _initDb();
    return _db!;
  }
}
