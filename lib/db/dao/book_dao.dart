import 'package:sqflite/sqflite.dart';

import '../../model/book.dart';
import '../database_helper.dart';

class BookDAO {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertBook(Book book) async {
    final db = await _databaseHelper.database;
    int result = await db.insert(
      'book',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<Book>> getBooks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('book');
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        pages: maps[i]['pages'],
        description: maps[i]['description'],
      );
    });
  }

  Future<Book?> getBookById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('book', where: 'id =?', whereArgs: [id]);
    // print(maps.first);
    if (maps.isNotEmpty) {
      print("Inside");
      print("the Book: ${Book.fromMap(maps.first)}");
      print("What");
      // const Duration(seconds: 10);
      return Book.fromMap(maps.first);
    }
    // print("Out");
    return null;
  }

  Future<int> deleteBook(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('book', where: 'id = ?', whereArgs: [id]);
  }
// Add other CRUD operations here (update, delete, etc.)
}
