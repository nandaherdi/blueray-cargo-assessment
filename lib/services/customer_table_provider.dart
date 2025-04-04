import 'package:blueray_cargo_assessment/models/customer_model.dart';
import 'package:blueray_cargo_assessment/services/db_context.dart';
import 'package:sqflite/sqflite.dart';

class CustomerTableProvider {
  final String tabelName = 'Customer';

  Future<List<CustomerModel>> getData({
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
      return CustomerModel(
        customerId: int.parse(maps[index]['customer_id']),
        email: maps[index]['email'],
        firstName: maps[index]['first_name'],
        lastName: maps[index]['last_name'],
        phoneNumber: maps[index]['phone_number'],
        gender: maps[index]['gender'],
        birthPlace: maps[index]['birth_place'],
        birthday: maps[index]['birthday'],
      );
    });
  }

  Future<String> insertData(CustomerModel customerData) async {
    String result = "Success";
    try {
      Database db = await DbContext.instance.database;
      await db.insert(tabelName, customerData.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> updateData(CustomerModel customerData) async {
    String result = "Success";
    try {
      Database db = await DbContext.instance.database;
      await db.update(
        tabelName,
        customerData.toJson(),
        where: 'customer_id = ?',
        whereArgs: [customerData.customerId],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> deleteData(CustomerModel customerData) async {
    String result = "Success";
    try {
      Database db = await DbContext.instance.database;
      await db.delete(tabelName, where: 'customer_id = ?', whereArgs: [customerData.customerId]);
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
