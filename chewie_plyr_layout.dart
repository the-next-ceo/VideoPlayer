// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';


class ChewiePlayerWidget extends StatelessWidget {
   ChewieController ?controller;

  ChewiePlayerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller!.isPlaying
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          //Positioned.fill(child: VideoPlayerLayout(controller: controller)),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller!.aspectRatio!,
        child: Chewie(controller: controller!,),
      );
}