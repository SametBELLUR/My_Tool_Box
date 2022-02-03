import 'dart:async';
import 'dart:io' as io;
import 'package:my_tool_box/models/ImageModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ImageDB {
  static final ImageDB instance = ImageDB._init();

  static Database? _db;
  ImageDB._init();

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _initDB('img.db');
    return _db!;
  }

  final String tableImage = 'image';
  final String columnId = 'id';
  final String columnPath = 'path';

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableImage($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnPath TEXT)');
  }

  Future<int> deleteImage(int id) async {
    final db = await instance.db;
    await db.transaction((txn) async {
      return await txn
          .rawDelete('DELETE FROM $tableImage WHERE $columnId = $id');
    });
    return -1;
  }

  Future<int> updateImage(int id, String path) async {
    final db = await instance.db;
    int effectedRows = await db.transaction((txn) async {
      return await txn.rawUpdate(
          "UPDATE $tableImage SET $columnPath= '$path' WHERE $columnId = $id");
    });
    return effectedRows;
  }

  void create(String path) async {
    final db = await instance.db;
    int id = await db.transaction((txn) async {
      return await txn
          .rawInsert("INSERT INTO $tableImage ($columnPath) VALUES('$path')");
    });
  }

  Future<List<ImageModel>> getImages() async {
    final db = await instance.db;
    final result = await db.query(tableImage);
    final List<ImageModel> list =
        await result.map((json) => ImageModel.fromJson(json)).toList();
    return list;
  }
}
