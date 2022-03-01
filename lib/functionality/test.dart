// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:vid_player/resources/chewie_plyr_layout.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  //String videoURL;

  // VideoWidget({required this.videoURL});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Chewie _chewie;
  late ChewieController _chewieController;
  String videoURL =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
  File file = File('');

  //_VideoWidgetState({required this.videoURL});

  @override
  void initState() {
    super.initState();
    /* _controller = VideoPlayerController.network(
      videoURL,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),

    ); */
    _controller = VideoPlayerController.file(file);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      showOptions: false,
      looping: false,
      autoInitialize: true,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      // allowPlaybackSpeedChanging: true,
    );
    _chewie = Chewie(
      controller: _chewieController,
    );
    _chewieController.addListener(() {
      if (!_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(padding: const EdgeInsets.only(top: 10)),
        /* Padding(padding: EdgeInsets.only(top: 10)),
          Text("Video",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), */
        Center(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  )
                : Center(
                    child: SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            strokeWidth: 1.0))),
          ),
        ),
        CupertinoButton(
          child: Text('Browse',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          color: Colors.indigo[700],
          padding: const EdgeInsets.all(18.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            _controller = VideoPlayerController.file(file);
            _controller.addListener(() {
              setState(() {});
            });
            _controller.setLooping(true);
            _controller.initialize();
            _chewieController = ChewieController(
              videoPlayerController: _controller,
              showOptions: true,
              autoInitialize: true,
              autoPlay: false,
              looping: true,
              allowFullScreen: true,
              deviceOrientationsOnEnterFullScreen: [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp
              ],
              allowPlaybackSpeedChanging: true,
            );
            _chewie = Chewie(
              controller: _chewieController,
            );
            /*  _chewieController.addListener(() {
              if (!_chewieController.isFullScreen) {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              }
            }); */
          },
        ),
      ]),
    );

    //return _chewie;
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    /* final result =
        (await FilePicker.platform.pickFiles(type: FileType.video)) as File; */
    if (result == null) {
      Fluttertoast.showToast(
          msg: "Please select the valid file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return File(result!.files.single.path!);
  }
}
