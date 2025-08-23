import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskplanner_demos/model_classes/listmodel.dart';

class DBhelper{
  static Future<Database> initDB() async{
    var dbPath=await getDatabasesPath();
    String path=join(dbPath,'Lists.db');

    return await openDatabase(path,version: 1,onCreate: _onCreate);
  }
  static Future _onCreate(Database db, int version) async {
    final sql = '''
    CREATE TABLE Lists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      namedid TEXT,
      colorValue INTEGER
    )
  ''';

    await db.execute(sql);
  }


  static Future<int> createLists(ListModel list) async{
    Database db=await initDB();
    return await db.insert('Lists', list.toMap());
  }
  static Future<List<ListModel>> readList() async{
    Database db=await initDB();
    var Lister=await db.query('Lists',orderBy: 'id'); // QUERY method in replacement of (select * from)
    List<ListModel> listOfList=Lister.isNotEmpty?
    Lister.map((instance)=>ListModel.fromMap(instance)).toList():[];
    return listOfList;
  }

  static Future<int> updateList(ListModel list) async{
    Database db=await initDB();
    return await db.update('Lists', list.toMap(),where: 'id= ?',whereArgs: [list.id]);
  }

  static Future<int> deleteList(int id) async{
    Database db=await initDB();
    return await db.delete('Lists',where: 'id= ?',whereArgs:[id]);
  }


}


