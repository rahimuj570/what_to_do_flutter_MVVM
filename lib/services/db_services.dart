import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbServices {
  static Database? _db;
  String dbName = 'what_to_do';

  Future<Database> _initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
create table todos(
id integer primary key autoincreament,
todo text not null,
deadline integer
)
''');
      },
    );
  }

  Future<Database> get getDatabase async {
    _db ??= await _initDb();
    return _db!;
  }
}
