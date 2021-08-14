import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:serr_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'userdata.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE userdata (
    id INTEGER PRIMARY KEY,
    name TEXT,
    userId TEXT,
    email TEXT,
    img TEXT,
    token TEXT
    )   
    ''');
  }

  Future<List<Map<String, Object?>>> getData() async {
    Database db = await instance.database;
    return await db.query('userdata');
    // List<UserModel> dataList =
    //     data.isNotEmpty ? data.map((e) => UserModel.fromJson(e)).toList() : [];
    // return dataList;
  }

  Future<int> insertData(UserModel userModel) async {
    Database db = await instance.database;
    return await db.insert('userdata', userModel.toMap());
  }

  Future<int> updateData(UserModel userModel) async {
    Database db = await instance.database;
    return await db.update('userdata', userModel.toMap());
  }

  Future<int> deleteData() async {
    Database db = await instance.database;
    return await db.delete('userdata');
  }
}
