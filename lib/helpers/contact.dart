import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final contactTable = 'contactTable';
final idColumn = 'idColumn';
final nameColumn = 'nameColumn';
final emailColumn = 'emailColumn';
final phoneColumn = 'phoneColumn';
final imgColumn = 'imgColumn';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

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
    final path = join(databasePath, 'database.db');

    return await openDatabase(path, version: 1,
        onCreate: (database, newerVersion) async {
      await database.execute('''
        CREATE TABLE $contactTable(
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
        )
      ''');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    final contactDb = await db;
    contact.id = await contactDb.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    final contactDb = await db;
    final List<Map> contacts = await contactDb.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);

    if (contacts.isNotEmpty) {
      return Contact.fromMap(contacts.first);
    } else {
      return null;
    }
  }

  Future<bool> deleteContact(int id) async {
    final contactDb = await db;
    final amountDeleted = await contactDb
        .delete(contactTable, where: '$idColumn = ? ', whereArgs: [id]);
    if (amountDeleted > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    final contactDb = await db;
    final amount = await contactDb.update(contactTable, contact.toMap(),
        where: '$idColumn  = ? ', whereArgs: [contact.id]);
    if (amount > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Contact>> getAllContacts() async {
    final contactDb = await db;
    final List maps = await contactDb.query(contactTable);

    if (maps.isEmpty) return null;

    final contacts = maps.map((m) => Contact.fromMap(m));
    return contacts.toList();
  }

  Future<int> getNumber() async {
    final contactDb = await db;
    final amount = Sqflite.firstIntValue(
        await contactDb.rawQuery('SELECT COUNT(*) from $contactTable'));
    return amount;
  }

  Future close() async {
    final contactDb = await db;
    contactDb.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact({this.name, this.email, this.phone, this.img, this.id});

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
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

  @override
  String toString() {
    return 'Contact(id $id, name: $name, email: $email, phone: $phone)';
  }
}
