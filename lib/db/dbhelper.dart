/*
  dbhelper.dart
    Perform operations on the QuickDial contact local database.
    Notice that here is no update method in this class.  If a contact is
    updated in Google contacts, the user should delete the local contact and then
    reselect it in the contact manager.
  Author : DenkaTech
  Created : 16/05/2022
    LM    : 16/05/2022
 */
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local_contact.dart';


class DatabaseHandler {
  /*
    Initialize database
   */
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    String sql = """CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        firstName TEXT,
        phoneNr TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";
    return openDatabase(join(path, 'quickdial.db'),
        onCreate: (database, version) async {
          await database.execute(sql);
        }, version: 2);
  }

  /*
    Returns a list of local contacts.  If nothing in the table, returns
    an empty list.
   */
  Future<List<LocalContact>> contacts() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('contacts');
    return queryResult.map((e) => LocalContact.fromMap(e)).toList();
  }

  /*
    Insert a contact
   */
  Future<void> insertContact(LocalContact lc) async {
    final db = await initializeDB();
    await db.insert('contacts', lc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /*
    Delete a contact from the LOCAL database
   */
  Future<void> deleteContact(int? id) async {
    final db = await initializeDB();
    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearContactsAll() async {
    final db = await initializeDB();
    await db.execute(("DELETE FROM Contacts"));
  }


}