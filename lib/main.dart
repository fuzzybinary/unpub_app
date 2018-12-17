import 'package:flutter/material.dart';
import 'package:unpub/screens/root_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 46, 85, 152),
        primaryColorLight: Color.fromARGB(255, 99, 129, 201),
        primaryColorDark: Color.fromARGB(255, 00, 45, 105),
        accentColor: Color.fromARGB(255, 228, 28, 36),
        bottomAppBarColor: Color.fromARGB(255, 46, 85, 152),
      ),
      home: RootScreen(),
    );
  }
}
