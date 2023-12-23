import 'dart:io';

import 'package:cards_app/models/person.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBPersonProvider {
  static Database? _database;
  static const DBFILENAME = 'person_database';
  static const PERSONTABLE = 'persons';

  // Creamos un patrón singleton
  static final DBPersonProvider db = DBPersonProvider._();

  // Se ejecutará el constructor
  DBPersonProvider._();

// Me retorna un DB
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  initDB() async {
    // Path donde está instalada la app
    Directory documentDirectory = await getApplicationCacheDirectory();
    final path = join(
      documentDirectory.path,
      '$DBFILENAME.db',
    ); // genera un archivo .db

    print('=========== Path: $path ====================');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE $PERSONTABLE(id INTEGER PRIMARY KEY, name TEXT, description TEXT, age INTEGER, pathimage TEXT )',
        );
      },
    );
  }

  /// Read
  Future<List<Person>> getAll() async {
    /// Forma de leer un dato por defecto
    /*return Future.value([
      Person('Christian Torres', 'Desarrollador de Software Junior', 30,
          'assets/chriss.jpg'),
      Person('Jorge Tigse', 'Administrador de Redes', 29, 'assets/jetona.jpg'),
    ]);*/

    // Leer BDD
    final db = await database;
    final response = await db!.query(PERSONTABLE);
    print('=====>TARJETAS: $response');

    List<Person> listPerson = response.isNotEmpty
        ? response.map((per) => Person.fromJson(per)).toList()
        : [];
    return listPerson;
  }

  /// Create
  Future<int> add(Person person) async {
    final db = await database;

    final response = await db!.insert(PERSONTABLE, person.toJson());

    return response;
  }

  /// Update
  Future<int> update(int id, Person person) async {
    final db = await database;
    final response = await db!.update(
      PERSONTABLE,
      person.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
    print('============> $response');
    return response;
  }

  /// Delete
  Future<int> delete(int id) async {
    final db = await database;
    final response = await db!.delete(
      PERSONTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('============> $response');
    return response;
  }

  /// Delete All
  Future<int> deleteAll() async {
    final db = await database;
    final response = await db!.delete(
      PERSONTABLE,
    );
    print('============> $response');
    return response;
  }
}
