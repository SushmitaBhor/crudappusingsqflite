import 'package:path/path.dart';
import 'package:simplified_singleton/sqflite/DataModel.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  //initialize db
  Future<Database> initDB() async {
    // path to store data
    String path = await getDatabasesPath();
    return openDatabase(join(path, "MYDB.db"),
        onCreate: (database, version) async {
      // logic for creating table
      // id required for updating or deleting
      await database.execute("""
      CREATE TABLE MYTable(id INTEGER PRIMERY KEY AUTOINCREMENT,title TEXT NOT NULL,
      subtitle TEXT NOT NULL
       )
      """);
    }, version: 1);
    // join is provided by path package
    // onCreate when openDatabase method execute then onCreate method also execute

    // inserting data in this table uses another method
  }

  Future<bool> insertData(DataModel dataModel) async {
    // have to create object of database using initDb() because initDb() returns database
    final Database db = await initDB();
    // map normal class object to json object
    db.insert("MYTable", dataModel.toMap());
    return true;
  }
}
