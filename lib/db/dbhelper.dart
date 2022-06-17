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

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/local_contact.dart';
import '../models/history.dart';

class DatabaseHandler {
  int callHistoryRecordCount = 0;
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
        listOrder INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";
    String sqlhistory = """CREATE TABLE callhistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        calledId INTEGER,
        called TEXT,        
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";
    return openDatabase(join(path, 'quickdial.db'),
        onCreate: (database, version) async {
      await database.execute(sql);
      await database.execute(sqlhistory);
    }, version: 4);
  }

  Future<void> createHistory() async {
    final db = await initializeDB();
    db.execute("""CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        calledId INTEGER,
        called TEXT,        
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""");
  }

  /*
    Call history data
   */
  Future<void> insertCallHistory(History history) async {
    final db = await initializeDB();
    await db.insert(
      'history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int get getCallHistoryCount => callHistoryRecordCount;

  Future<void> deleteHistory(int? id) async {
    final db = await initializeDB();
    await db.delete(
      'history',
      where: 'calledId = ?',
      whereArgs: [id],
    );
  }

  /*
    Returns a list of calls to a contact
   */
  Future<List<History>> getCallHistory(int id) async {
    final db = await initializeDB();
    String sql = "SELECT * FROM history WHERE calledId = $id ORDER BY id DESC";
    var result = await db.rawQuery(sql);

    List<History> list = result.map((item) {
      return History.fromMap(item);
    }).toList();
    callHistoryRecordCount = list.length;
    return list;
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
    await db.insert(
      'contacts',
      lc.toMap(),
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
    await deleteHistory(id);
  }

  Future<void> clearContactsAll() async {
    final db = await initializeDB();
    await db.execute(("DELETE FROM Contacts"));
  }
}
