import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/settings_model.dart';
import '../settings/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsProvider _settingsProvider = SettingsProvider();
  late Future<Settings> _settingsFuture;
  late String _sortingCriteria;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _settingsProvider.getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Settings>(
      future: _settingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No settings data'));
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading settings'));
        } else {
          final settings = snapshot.data!;
          _sortingCriteria = settings.sortingCriteria;

          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Consumer<ThemeNotifier>(
                    builder: (context, themeNotifier, child) {
                      return SwitchListTile(
                        title: const Text('Dark Mode'),
                        value: themeNotifier.isDarkMode,
                        onChanged: (value) {
                          themeNotifier.toggleTheme();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _sortingCriteria,
                    decoration: const InputDecoration(labelText: 'Sort By'),
                    items: const [
                      DropdownMenuItem(
                        value: 'title',
                        child: Text('Title'),
                      ),
                      DropdownMenuItem(
                        value: 'author',
                        child: Text('Author'),
                      ),
                      DropdownMenuItem(
                        value: 'date',
                        child: Text('Date Added'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortingCriteria = value!;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _saveSettings() {
    final settings = Settings(
      isDarkMode: Provider.of<ThemeNotifier>(context, listen: false).isDarkMode,
      sortingCriteria: _sortingCriteria,
    );
    _settingsProvider.saveSettings(settings);
  }
}
