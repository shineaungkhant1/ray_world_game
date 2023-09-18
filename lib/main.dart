import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:ray_world_game/pages/main_game_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ray World Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainGamePage(),
    );
  }
}

