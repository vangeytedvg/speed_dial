/*
  sdl_helper.dart
  Perform operations on the QuickDial contact local database
  Author : DenkaTech
  Created : 16/05/2022
    LM    : 16/05/2022
 */
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    String sql = """CREATE TABLE contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      firstName TEXT,
      phonenr TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""";
    await database.execute(sql);
    // Second statement creates index
    sql = """CREATE INDEX idx_contact_name ON contacts (name)""";
    await database.execute(sql);
  }

  /*
    Get a reference to the database, if the database does not yet exist,
    it will be created first!
   */
  static Future<sql.Database> db() async {
    return sql.openDatabase('denkatech.db', version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        });
  }

  /*
    Create a new contact
   */
  static Future<int> createItem(String name, String? firstName, String phoneNumber) async {
    // Get reference to db
    final db = await SQLHelper.db();
    // Prepare the data string
    final data = {'name': name, 'firstName': firstName, 'phoneNr': phoneNumber};

    // Insert into the database and recover the new id
    final id = await db.insert('contacts', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  /*
    Get a list of all the local contacts, ordered by name
   */
  static Future<List<Map<String, dynamic>>> getItems() async {
    // Get reference to db
    final db = await SQLHelper.db();
    return db.query('contacts', orderBy: 'name');
  }

  /*
    Get a single item by it's id
   */
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    // Get reference to db
    final db = await SQLHelper.db();
    return db.query('contacts', where: "id = ?", whereArgs: [id], limit: 1);
  }
}
