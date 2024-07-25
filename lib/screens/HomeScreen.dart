import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mid/db/dao/book_dao.dart';
import '../components.dart';
import '../model/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bookDao = BookDAO();
  late Future<List<Book>> _books;
  late List<Book> _filteredBooks;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _books = bookDao.getBooks();
    _filteredBooks = [];
    _books.then((books) {
      if (!mounted) return;
      setState(() {
        _filteredBooks = books;
      });
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      _books.then((books) {
        _filteredBooks = books
            .where((book) =>
                book.title.toLowerCase().contains(query.toLowerCase()) ||
                book.author.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
          onChanged: _filterBooks,
        ),
      ),
      body: Align(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Sans(text: "Add a Book", size: 16.0),
                    IconButton(
                      onPressed: () {
                        showGeneralDialog(
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
                                          children: const [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [AddBookForm()],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                            barrierColor: Colors.black38,
                            barrierLabel: 'Label',
                            barrierDismissible: false);
                      },
                      icon: const Icon(
                        CupertinoIcons.add,
                        color: Colors.green,
                      ),
                      hoverColor: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                FutureBuilder<List<Book>>(
                  future: _books,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error : ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No books Found'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _filteredBooks.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final book = _filteredBooks[index];
                          return ListTile(
                            title: Text(book.title),
                            subtitle: Text(book.author),
                            onTap: () {
                              print(book.id);
                              context.goNamed("details",
                                  pathParameters: {'id': book.id.toString()});
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
