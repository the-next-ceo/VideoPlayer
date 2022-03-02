import 'package:flutter/material.dart';
import 'package:vid_player/functionality/paint.dart';
import 'package:vid_player/functionality/test.dart';
import 'package:vid_player/functionality/video.dart';
import 'package:vid_player/functionality/watch.dart';
import 'package:vid_player/tab_nav/tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DrawingPage(),
    );
  }
}
