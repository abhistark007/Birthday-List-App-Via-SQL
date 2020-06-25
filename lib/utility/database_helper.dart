import 'dart:core';
import 'dart:io';
import 'package:birthday_app_sql/models/birthday.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DatabaseHelper {
  
  String tableName='Birthday_Table';
  String colId='id';
  String colName='name';
  String colDate='date';
  static DatabaseHelper _databaseHelper;
  static Database _database;
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper=DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database=await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path+'bday.db';
    var bdayDatabase=await openDatabase(path,version:1,onCreate: _createDb);
    return bdayDatabase;
  }
  void _createDb(Database db,int newVersion) async{
    await db.execute('''
    CREATE TABLE $tableName (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT,
      $colDate TEXT
    )
    ''');
  }
  Future<List<Map<String,dynamic>>> getBdayMapList() async{
    Database db=await this.database;
    var result=await db.query(tableName,orderBy: '$colId ASC');
    return result;
  }
  Future<int> insertBirthday(Birthday bday) async{
    Database db=await this.database;
    var result= await db.insert(tableName,bday.toMap());
    return result;
  }
  Future<int> updateBirthday(Birthday bday) async{
    var db= await this.database;
    var result=await db.update(tableName, bday.toMap(),where: '$colId = ?',whereArgs: [bday.id]);
    return result;
  }
  Future<int> deleteBirthday(int id) async{
    var db=await this.database;
    int result=await db.rawDelete('''
    DELETE FROM $tableName WHERE $colId = $id
    ''');
    return result;
  }
  Future<int> getCount() async{
    Database db=await this.database;
    List<Map<String,dynamic>> x=await db.rawQuery('''
    SELECT COUNT(*) 
    FROM $tableName
    ''');
    int result=Sqflite.firstIntValue(x);
    return result;
  }
  Future<List<Birthday>> getBdayList() async{
    var bdayMapList=await getBdayMapList();
    int count=bdayMapList.length;
    List<Birthday> bdayList=List<Birthday>();
    for(int i=0;i<count;i++){
      bdayList.add(Birthday.fromMapToObject(bdayMapList[i]));
    }
    return bdayList;
  }
}