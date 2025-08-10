import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskplanner_demos/model_classes/taskmodel.dart';
class DBTaskHelper{
  static Future<Database> initDB()async{
      var dbpath= await getDatabasesPath();
      String path=join(dbpath,'Tasks.db');

      return await openDatabase(path,version: 1,onCreate: _onCreate);
  }
  static Future _onCreate(Database db,int version) async{
      final fqp='''
      CREATE TABLE Tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        listId INTEGER NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        isDone INTEGER NOT NULL
        )
      ''';
      await db.execute(fqp);
  }
  static Future<int> createTasks(Task task) async{
    Database db=await initDB();
    return await db.insert('Tasks',task.toJson());
  }

  static Future<int> updateTask(Task task) async{
      Database db=await initDB();
      return db.update('Tasks',task.toJson(),where: 'id=?',whereArgs: [task.id]);
  }
  static Future<List<Task>> readTask(int ListID) async{
    Database db= await initDB();
    var tasker= await db.query('Tasks',where: 'listId=?',whereArgs: [ListID],orderBy: 'id');
    List<Task> listofTasks=tasker.isNotEmpty?
    List.generate(tasker.length, (i)=>Task.fromJson(tasker[i])):[];
    return listofTasks;
  }
  static Future<int> deleteTask(int id) async{
    Database db=await initDB();
    return await db.delete('Tasks',where: 'id=?',whereArgs: [id]);
  }
}