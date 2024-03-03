import 'package:flutter/material.dart';
import 'package:mp2/views/yahtzee.dart';

void main() {
  runApp(const YahtzeeApp());
}

class YahtzeeApp extends StatelessWidget {
  const YahtzeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //for removing the debug banner
      title: 'Yahtzee Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const YahtzeePage(),
    );
  }
}
