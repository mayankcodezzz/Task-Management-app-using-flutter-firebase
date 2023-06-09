import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'list.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();
  /// singleton in flutter
  /// Simply put, a singleton ensures that a class has only one instance in all applications and provides a global access point.
  /// An instance or object of a Class is a concrete and specific representation of a Class
  /// The Singleton pattern is one of many design patterns that guarantees that a class has only one instance; and it is basically that; for this, object-oriented programming is used. In Flutter, the Singleton pattern is often used in combination with the Material layout to provide global access to certain Material widgets used in the app.
  /// For example, a singleton DatabaseHelper can be used to provide global access to an SQLite database; this is an implementation that I commonly do in the Flutter course and in my apps; These types of adaptations are common in Flutter and facilitate the process of creating organized, modular and scalable applications.
  /// In general, the implementation of a Singleton pattern in Flutter follows the same principles as in any other programming language, ensuring that only one instance of a given class is created, and providing a global access point for that instance.
  DatabaseHelper._();

  late Database db;
  /// using a factory is important
  /// because it promises to return _an_ object of this type
  /// but it doesn't promise to make a new one.
  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    ///here we have added await before as getDatabasesPath as
    String path = await getDatabasesPath();
    ///using this we can assign path of database a name here user_emo.db
    db = await openDatabase(
      join(path, 'users_emo.db'),
      //here on create we  basically do on execute Future<void> execute(String sql, [List<Object?>? arguments]);
      onCreate: (database, version) async {
        ///A sql string is passed
        await database.execute(
          """
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              noteTitle TEXT NOT NULL,
              noteContent TEXT NOT NULL,
              noteTime TEXT NOT NULL,
              noteDate TEXT NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(User user) async {
    int result = await db.insert('users', user.toMap());
    return result;
  }

  Future<int> updateUser(User user) async {
    int result = await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<List<User>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteUser(int id) async {
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
