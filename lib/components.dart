import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mid/db/dao/book_dao.dart';

import 'model/book.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  const MyAppBar({super.key, @required this.title});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: Colors.blueAccent,
      elevation: 20.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Book Store"),
          Icon(
            CupertinoIcons.book_circle,
            color: Colors.green,
            size: 40.0,
          ),
          SizedBox(
            height: 40.0,
          ),
          Column(
            children: [
              MyTab(
                title: "Home",
                route: "/",
                icon: Icons.home,
              ),
              SizedBox(
                height: 20.0,
              ),
              MyTab(
                title: "Settings",
                route: "/settings",
                icon: Icons.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyTab extends StatelessWidget {
  final title;
  final route;
  final icon;
  const MyTab(
      {super.key,
      @required this.title,
      @required this.route,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        context.go(route);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      color: Colors.black12,
      elevation: 10.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(
            width: 10.0,
          ),
          Icon(icon)
        ],
      ),
    );
  }
}

class TextForm extends StatelessWidget {
  final title;
  final width;
  final maxLines;
  final hintText;
  final controller;
  const TextForm(
      {super.key,
      @required this.title,
      this.maxLines,
      @required this.hintText,
      @required this.width,
      @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(child: Sans(text: title, size: 16.0)),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: width,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            onTap: () {},
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(fontSize: 15.0),
              hintText: hintText,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: Colors.tealAccent, style: BorderStyle.solid)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                  borderSide:
                      BorderSide(color: Colors.teal, style: BorderStyle.solid)),
            ),
          ),
        )
      ],
    );
  }
}

class Sans extends StatelessWidget {
  final text;
  final size;

  final isdecorated;
  const Sans(
      {super.key, @required this.text, @required this.size, this.isdecorated});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: size,
      ),
    );
  }
}

class SansBold extends StatelessWidget {
  final text;
  final size;

  final isdecorated;
  const SansBold(
      {super.key, @required this.text, @required this.size, this.isdecorated});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
          color: Theme.of(context).dialogBackgroundColor,
          fontSize: size,
          fontWeight: FontWeight.bold,
          decoration: !isdecorated ? null : TextDecoration.underline),
    );
  }
}

class AddBookForm extends StatefulWidget {
  const AddBookForm({super.key});

  @override
  State<AddBookForm> createState() => _AddBookFormState();
}

class _AddBookFormState extends State<AddBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final bookDao = BookDAO();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SansBold(
            text: "Add A book",
            size: 40.0,
            isdecorated: true,
          ),
          TextForm(
              controller: _titleController,
              title: "Book Name",
              hintText: "Enter Book Name",
              width: 300.0),
          const SizedBox(
            height: 12.0,
          ),
          TextForm(
              controller: _authorController,
              title: "Author",
              hintText: "Enter Author",
              width: 300.0),
          const SizedBox(
            height: 12.0,
          ),
          TextForm(
              controller: _pagesController,
              title: "Pages",
              hintText: "How Many Pages",
              width: 300.0),
          TextForm(
            controller: _descriptionController,
            title: "Description",
            hintText: "Enter Short Description or Summary",
            width: MediaQuery.of(context).size.width / 1.5,
            maxLines: 5,
          ),
          const SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final book = Book(
                        title: _titleController.text,
                        author: _authorController.text,
                        pages: int.parse(_pagesController.text),
                        description: _descriptionController.text);
                    var result = await bookDao.insertBook(book);
                    var saved = result > 0;
                    String message =
                        saved ? "Saved Successfully" : "Save Failed";
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20.0),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"))
                            ],
                            title: const Text("Message"),
                            content: Text(message),
                          );
                        });
                  }
                  // var title =
                },
                color: Colors.white,
                elevation: 10.0,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Sans(text: "Save", size: 20.0),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 20.0,
                    )
                  ],
                ),
              ),
              MaterialButton(
                shape: const RoundedRectangleBorder(
                    side:
                        BorderSide(color: Colors.red, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                elevation: 10.0,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Sans(text: "Cancel", size: 20.0),
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 20.0,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EditBookForm extends StatefulWidget {
  final id;
  final context;
  const EditBookForm({super.key, this.id, this.context});

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pagesController = TextEditingController();
  final _descriptionController = TextEditingController();

  final BookDAO _bookDao = BookDAO();
  late Future<Book?> _book;

  @override
  void initState() {
    _book = _bookDao.getBookById(widget.id);
    _book.then((value) {
      _titleController.text = value!.title;
      _descriptionController.text = value.description;
      _authorController.text = value.author;
      _pagesController.text = (value.pages).toString();
    });
  }

  void setControllers() async {}

  @override
  Widget build(BuildContext context) {
    context = widget.context;
    return FutureBuilder(
      future: _book,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("There is no Data"),
          );
        } else {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SansBold(
                  text: "Edit A book",
                  size: 40.0,
                  isdecorated: true,
                ),
                TextForm(
                    controller: _titleController,
                    title: "Book Name",
                    hintText: "Enter Book Name",
                    width: 300.0),
                const SizedBox(
                  height: 12.0,
                ),
                TextForm(
                    controller: _authorController,
                    title: "Author",
                    hintText: "Enter Author",
                    width: 300.0),
                const SizedBox(
                  height: 12.0,
                ),
                TextForm(
                    controller: _pagesController,
                    title: "Pages",
                    hintText: "How Many Pages",
                    width: 300.0),
                TextForm(
                  controller: _descriptionController,
                  title: "Description",
                  hintText: "Enter Short Description or Summary",
                  width: MediaQuery.of(context).size.width / 1.5,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final book = Book(
                              id: widget.id,
                              title: _titleController.text,
                              author: _authorController.text,
                              pages: _pagesController.text == null
                                  ? null
                                  : int.parse(_pagesController.text),
                              description: _descriptionController.text);
                          var result = await _bookDao.insertBook(book);
                          var saved = result > 0;
                          String message =
                              saved ? "Saved Successfully" : "Save Failed";
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(20.0),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Close"))
                                  ],
                                  title: const Text("Message"),
                                  content: Text(message),
                                );
                              });
                        }
                        // var title =
                      },
                      color: Colors.white,
                      elevation: 10.0,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Sans(text: "Edit", size: 20.0),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20.0,
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.red, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.of(context).pop(false);
                      },
                      color: Colors.white,
                      elevation: 10.0,
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Sans(text: "Cancel", size: 20.0),
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 20.0,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}
