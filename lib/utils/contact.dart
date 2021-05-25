import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactUtils {
  static final ContactUtils _instance = ContactUtils.internal();

  factory ContactUtils() => _instance;

  ContactUtils.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contactsnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $contactTable ($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,'
          '$phoneColumn TEXT, $imgColumn TEXT)');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database _dataBase = await db;
    contact.id = await _dataBase.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database _dataBase = await db;
    List listContact = await _dataBase.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (listContact.length > 0) {
      return Contact.fromMap(listContact.first);
    }
    return null;
  }

  Future<int> deleteContact(int id) async {
    Database _dataBase = await db;
    return await _dataBase
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database _database = await db;
    return await _database.update(contactTable, contact.toMap(),
        where: "$idColumn", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database _database = await db;
    List listMap = await _database.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = [];
    for (Map map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database _database = await db;
    return Sqflite.firstIntValue(
        await _database.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[emailColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
