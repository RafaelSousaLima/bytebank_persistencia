import 'package:bytebank/contact.dart';
import 'package:bytebank/database/app_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  static const String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  Future<int> save(Contact contact) async {
    debugPrint('Save ContactDao');
    debugPrint(contact.toString());
    final Database db = await getDataBase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Contact contact) async {
    final Database db = await getDataBase();
    await db.update(_tableName, _toMap(contact),
        where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  Future<Contact> findById(Contact contact) async {
    final Database db = await getDataBase();
    List<Map<String, Object>> result =
        await db.query(_tableName, where: '$_id = ?', whereArgs: [contact.id]);
    return _toList(result).first;
  }

  Future<int> delete(Contact contact) async {
    final Database db = await getDataBase();
    return db.delete(_tableName, where: '$_id = ?', whereArgs: [contact.id]);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in result) {
      contacts.add(Contact(row[_id], row[_name], row[_accountNumber]));
    }
    return contacts;
  }
}
