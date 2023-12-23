import 'package:cards_app/screen/card_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cards',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const CardScreen(),
    );
  }
}