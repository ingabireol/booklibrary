import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class Book {
  int? id;
  final String title;
  final String author;
  final int? pages;
  final String description;
  final String? imagePath;
  final bool read;
  final double rating;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.pages,
    required this.description,
    this.imagePath,
    this.read = false,
    this.rating = 0.0,
  });

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, pages: $pages, description: $description, imagePath: $imagePath, read: $read, rating: $rating}';
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'pages': pages,
      'description': description,
      'imagePath': imagePath,
      'read': read ? 1 : 0,
      'rating': rating,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    print(map);
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      pages: map['pages'],
      description: map['description'],
      imagePath: map['imagePath'],
      read: map['read'] == 1,
      rating: map['rating'],
    );
  }

  static Future<void> saveBook(Book book) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'library_app.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE IF NOT EXISTS book ("
            "id INTEGER PRIMARY KEY, "
            "title TEXT, "
            "author TEXT, "
            "pages INTEGER, "
            "description TEXT, "
            "imagePath TEXT, "
            "read INTEGER, "
            "rating REAL"
            ")");
      },
      version: 1,
    );
    final db = await database;
    await db.insert(
      'book',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
