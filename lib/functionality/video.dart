import 'package:flutter/material.dart';
import 'package:vid_player/functionality/paint.dart';
import 'package:vid_player/functionality/test.dart';

class VideoPlayer extends StatefulWidget {
  //const VideoPlayer({ Key? key }) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //VideoWidget(),
        DrawingPage(),
      ],
    );
  }
}
