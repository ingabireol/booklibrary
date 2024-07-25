import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mid/routes.dart';
import 'package:mid/settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Example usage: save a book
  // BookDAO bookDAO = BookDAO();
  // Book book = Book(
  //   id: 6,
  //   title: "Good Morning Holy Spirit",
  //   author: "Benny Hinn",
  //   pages: 120,
  //   description: "Being with God Eternally",
  // );
  // var result = await bookDAO.insertBook(book);
  // print(result);
  // print(await bookDAO.getBooks());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeSettingsProvider(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading settings'));
        } else {
          final settingsProvider = snapshot.data as SettingsProvider;
          return ChangeNotifierProvider(
            create: (_) => ThemeNotifier(settingsProvider),
            child: Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return MaterialApp.router(
                  routerConfig: Routes.generateRoutes(),
                  debugShowCheckedModeBanner: false,
                  theme: themeNotifier.currentTheme,
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<SettingsProvider> _initializeSettingsProvider() async {
    final settingsProvider = SettingsProvider();
    await settingsProvider.loadTheme(); // Ensure the settings are loaded
    return settingsProvider;
  }
}
