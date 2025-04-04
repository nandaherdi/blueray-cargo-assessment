import 'dart:io';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DbContext {
  DbContext._constructor();
  static final DbContext instance = DbContext._constructor();
  static Database? _database;

  String get _authTableName => 'Authorization';
  String get _customerTableName => 'Customer';
  String get _dbName => 'BluerayCargo.db';
  int get _currentVersion => 1;
  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    final String path = join(await getDatabasesPath(), _dbName);
    bool dbExists = await File(join(await getDatabasesPath(), _dbName)).exists();
    if (dbExists) {
      return await openDatabase(path, version: _currentVersion);
    } else {
      return await openDatabase(path, version: _currentVersion, onCreate: _onCreate);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_authTableName (
        token               TEXT,
        token_expiry_date   TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $_customerTableName (
        customer_id        TEXT,
        email              TEXT,
        first_name         TEXT,
        last_name          TEXT,
        phone_number       TEXT,
        gender             TEXT,
        birth_place        TEXT,
        birthday           TEXT
      )
    ''');
  }

  Future<bool> destroyDB() async {
    String dbPath = join(await getDatabasesPath(), _dbName);

    bool dbExists = await File(dbPath).exists();

    if (dbExists) {
      await deleteAllData(_authTableName);
    }
    return true;
  }

  Future<void> deleteAllData(String tableName) async {
    Database? db = await _initDb();
    await db.delete(tableName);
  }
}
