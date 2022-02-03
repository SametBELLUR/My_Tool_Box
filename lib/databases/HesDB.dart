import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_tool_box/models/HesCodeModel.dart';

class HesDB {
  static final HesDB instance = HesDB._init();

  static Database? _db;
  HesDB._init();

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _initDB('hes.db');
    return _db!;
  }

  final String tableHes = 'hesCode';
  final String columnId = 'id';
  final String columnHes = 'hes';

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableHes($columnId INTEGER PRIMARY KEY AUTOINCREMENT,$columnHes TEXT)');
  }

  Future<int> deleteHes(int id) async {
    final db = await instance.db;
    await db.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM $tableHes WHERE $columnId = $id');
    });
    return -1;
  }

  Future<int> updateHes(int id, String hes) async {
    final db = await instance.db;
    int effectedRows = await db.transaction((txn) async {
      return await txn.rawUpdate(
          "UPDATE $tableHes SET $columnHes= '$hes' WHERE $columnId = $id");
    });
    return effectedRows;
  }

  void create(String hesCode) async {
    final db = await instance.db;
    int id = await db.transaction((txn) async {
      return await txn
          .rawInsert("INSERT INTO $tableHes ($columnHes) VALUES('$hesCode')");
    });
  }

  Future<List<HesCodeModel>> getHesCode() async {
    final db = await instance.db;
    final result = await db.query(tableHes);
    final List<HesCodeModel> list =
        await result.map((json) => HesCodeModel.fromJson(json)).toList();
    if (list.length == 0) {
      list.add(new HesCodeModel(id: 0, hes: "-"));
    }
    return list;
  }
}
