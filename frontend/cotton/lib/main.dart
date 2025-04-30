import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      return ShadApp.material(
      title: 'Cotton',
      theme: ShadThemeData(colorScheme: ShadGreenColorScheme.light(), brightness: Brightness.light),
      darkTheme: ShadThemeData(colorScheme: ShadGreenColorScheme.dark(), brightness: Brightness.dark),
      home: HomePage()
    );
  }
}
