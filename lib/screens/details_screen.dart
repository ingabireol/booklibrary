import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mid/db/dao/book_dao.dart';
import '../components.dart';
import '../model/book.dart';

class DetailsScreen extends StatefulWidget {
  final int id;

  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final BookDAO bookDAO = BookDAO();
  late Future<Book?> _book;

  @override
  void initState() {
    super.initState();
    _book = bookDAO.getBookById(widget.id);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this book?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                var deleted = await _deleteBook();
                String message =
                    deleted > 0 ? "Deleted Successfully" : "Delete Failed";
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(20.0),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.go('/');
                          },
                          child: const Text("Close"),
                        ),
                      ],
                      title: const Text("Message"),
                      content: Text(message),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<int> _deleteBook() async {
    return await bookDAO.deleteBook(widget.id);
  }

  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: const MyAppBar(
        title: 'Details',
      ),
      body: FutureBuilder<Book?>(
        future: _book,
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No such Book"),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Some Error Occurred"),
            );
          } else {
            Book? book = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            book!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: Container(
                            height: 200,
                            width: 150,
                            color: Colors.white,
                            child: book.imagePath != null
                                ? Image.file(
                                    File(book.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Text(
                                      'Book Cover',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Read Status",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              book.read ? "Read" : "Unread",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          book.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Rating",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        PannableRatingBar(
                          rate: book.rating,
                          items: List.generate(
                            5,
                            (index) => const RatingWidget(
                              selectedColor: Colors.yellow,
                              unSelectedColor: Colors.grey,
                              child: Icon(
                                Icons.star,
                                size: 48,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 100,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 100,
                                bottom: 5.0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    _showDeleteConfirmationDialog();
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 5.0,
                                right: 4.0,
                                child: IconButton(
                                  onPressed: () async {
                                    var result = await showGeneralDialog(
                                      context: context,
                                      pageBuilder: (_, __, ___) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: kTextTabBarHeight,
                                              left: 50.0,
                                              right: 50.0),
                                          child: Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                color: Theme.of(context)
                                                    .dialogBackgroundColor,
                                                child: ListView(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        EditBookForm(
                                                          context: context,
                                                          id: widget.id,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      barrierColor: Theme.of(context)
                                          .dialogBackgroundColor,
                                      barrierLabel: 'Label',
                                      barrierDismissible: false,
                                    );
                                    context.go('/');
                                    context.goNamed("details", pathParameters: {
                                      'id': book.id.toString()
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
