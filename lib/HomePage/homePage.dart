import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:status_saver/HomePage/mainPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final text = '<h3><b></b>';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Saver'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: const Icon(Icons.lightbulb_outline)),
        ],
        bottom: TabBar(tabs: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: const Text(
              'IMAGES',
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            child: const Text(
              'VIDEOS',
            ),
          ),
        ]),
      ),
      body: const MainPage(),
    );
  }
}
