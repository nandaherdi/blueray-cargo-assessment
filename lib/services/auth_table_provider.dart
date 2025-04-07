import 'package:blueray_cargo_assessment/models/authorization_model.dart';
import 'package:blueray_cargo_assessment/services/db_context.dart';
import 'package:sqflite/sqflite.dart';

class AuthorizationTableProvider {
  final String tabelName = 'Authorization';

  Future<List<AuthorizationModel>> getData({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    // final List<Map<String, dynamic>> maps = await DbContext.instance.database.then((db) {
    //   return db.query(
    //     tabelName,
    //     distinct: distinct,
    //     columns: columns,
    //     where: where,
    //     whereArgs: whereArgs,
    //     groupBy: groupBy,
    //     having: having,
    //     orderBy: orderBy,
    //     limit: limit,
    //     offset: offset,
    //   );
    // });
    Database db = await DbContext.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tabelName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (index) {
      return AuthorizationModel(
        token: maps[index]['token'],
        tokenExpiryDate: DateTime.parse(maps[index]['token_expiry_date']),
      );
    });

    // return List.generate(maps.length, (index) {
    //   return authorizationModelFromJson(maps[index].toString());
    // });
  }

  Future<String> insertData(AuthorizationModel authData) async {
    String result = "Success";
    try {
      // await DbContext.instance.database.then((db) {
      //   db.insert(tabelName, authData.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      // });
      Database db = await DbContext.instance.database;
      await db.insert(tabelName, authData.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> updateData(AuthorizationModel authData) async {
    String result = "Success";
    try {
      // await DbContext.instance.database.then((db) {
      //   db.update(
      //     tabelName,
      //     authData.toJson(),
      //     where: 'UserID = ?',
      //     whereArgs: [authData.token],
      //     conflictAlgorithm: ConflictAlgorithm.fail,
      //   );
      // });
      Database db = await DbContext.instance.database;
      await db.update(
        tabelName,
        authData.toJson(),
        where: 'token = ?',
        whereArgs: [authData.token],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> deleteData(AuthorizationModel authData) async {
    String result = "Success";
    try {
      Database db = await DbContext.instance.database;
      await db.delete(tabelName, where: 'token = ?', whereArgs: [authData.token]);
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> truncateData() async {
    String result = "Success";
    try {
      Database db = await DbContext.instance.database;
      await db.delete(tabelName);
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
